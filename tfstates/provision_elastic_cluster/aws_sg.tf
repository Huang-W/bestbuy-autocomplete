module "elastic_node_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "elastic-nodes"
  description = "security group for elastisearch nodes with custom ports open to VPC and ssh port open to jumpbox"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = data.terraform_remote_state.vpc.outputs.vpc_private_subnet_cidrs
  ingress_rules = ["elasticsearch-rest-tcp", "elasticsearch-java-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule = "ssh-tcp"
      source_security_group_id = data.terraform_remote_state.vpc.outputs.jumpbox_sg_id
    }
  ]
}
