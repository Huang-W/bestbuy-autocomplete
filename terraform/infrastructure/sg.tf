# module "node_sg" {
#   source = "terraform-aws-modules/security-group/aws"
#
#   name        = "eks-node-group"
#   description = "security group for eks worker nodes with http open to VPC subnets"
#   vpc_id      = module.vpc.vpc_id
#
#   ingress_cidr_blocks = concat(var.vpc_public_subnets, var.vpc_private_subnets)
#   ingress_rules       = ["http-80-tcp", "https-443-tcp"]
#   ingress_with_self = [{
#     rule = "ssh-tcp"
#   }]
# }


# replace module with aws_security_group
module "elasticache_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "elasticache-node-group"
  description = "security group for elasticache nodes with redis-tcp open to eks subnets"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress_cidr_blocks = var.private_subnets # change this to pod security groups
  ingress_rules       = ["redis-tcp"]
}

output "elasticache_security_group_id" {
  value = module.elasticache_sg.security_group_id
}

# replace module with aws_security_group
module "postgres_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "postgres-db-group"
  description = "security group for postgres db with postgresql-tcp open to eks subnets"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress_cidr_blocks = var.private_subnets # change this to pod security groups
  ingress_rules       = ["postgresql-tcp"]
}

output "postgres_security_group_id" {
  value = module.postgres_sg.security_group_id
}
