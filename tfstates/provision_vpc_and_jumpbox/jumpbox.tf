resource "random_pet" "this" {
  length = 2
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
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

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = random_pet.this.id
  public_key = tls_private_key.this.public_key_openssh
}

module "jumpbox" {
  source = "terraform-aws-modules/ec2-instance/aws"
  instance_count = 1

  name = "jumpbox"
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  key_name = module.key_pair.this_key_pair_key_name
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.jumpbox_sg.this_security_group_id]
  # associate_public_ip_address = true
}
