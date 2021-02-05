module "jumpbox_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh_public"
  description = "Security group for jumpbox with ssh port open to home network"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.my_home_network]
}
