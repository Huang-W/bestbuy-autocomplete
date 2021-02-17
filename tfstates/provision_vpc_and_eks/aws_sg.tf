module "jumpbox_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh_public"
  description = "Security group for jumpbox with ssh port open to home network"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.my_home_network]
}

module "node_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "eks-node-group"
  description = "security group for eks worker nodes with http open to VPC subnets, and ssh port open to jumpbox"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = concat(var.vpc_public_subnets, var.vpc_private_subnets)
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.jumpbox_sg.this_security_group_id
    }
  ]
}

module "elasticache_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "elasticache-node-group"
  description = "security group for elasticache nodes with redis-tcp open to eks subnets"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.vpc_private_subnets
  ingress_rules       = ["redis-tcp"]
}
