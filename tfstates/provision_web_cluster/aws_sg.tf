module "web_node_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-nodes"
  description = "security group for elastisearch nodes with http open to VPC private subnets, and ssh port open to jumpbox"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = concat(data.terraform_remote_state.vpc.outputs.vpc_public_subnet_cidrs, data.terraform_remote_state.vpc.outputs.vpc_private_subnet_cidrs)
  ingress_rules       = ["http-8080-tcp", "https-8443-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = data.terraform_remote_state.vpc.outputs.jumpbox_sg_id
    }
  ]
}
