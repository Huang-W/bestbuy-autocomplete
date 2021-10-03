# AWS AMI for jumpbox
########################################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}
########################################################


# Bastion host in public subnet
########################################################
module "jumpbox" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.1.0"

  name          = "jumpbox"
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  key_name               = module.key_pair_jumpbox.key_pair_key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.jumpbox_sg.security_group_id]
  # associate_public_ip_address = true
}
########################################################
