#
# https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml
#
resource "aws_vpc" "bestbuy_vpc" {
  cidr_block = "10.1.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "bestbuy-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bestbuy_vpc.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "bestbuy-${aws_subnet.private_1.availability_zone_id}"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.my_aws_public_key
}

variable "my_home_network" {
  type    = string
  # default = "0.0.0.0/0"
}

variable "my_aws_public_key" {
  type = string
  # default = ""
}
