
# Network Interface
###########################################
resource "aws_network_interface" "jumpbox" {
  subnet_id = aws_subnet.public_1.id
  private_ips = ["10.1.0.5"]
  security_groups = [
    aws_security_group.ssh_inbound.id,
    aws_security_group.allow_all.id
  ]
  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_network_interface" "web" {
  subnet_id = aws_subnet.public_1.id
  private_ips = ["10.1.0.6"]
  security_groups = [
    aws_security_group.http_inbound.id,
    aws_security_group.allow_all.id,
    aws_security_group.internal_public.id
  ]
  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_network_interface" "elastic" {
  subnet_id = aws_subnet.private_1.id
  private_ips = ["10.1.3.4"]
  security_groups = [
    aws_security_group.elastic_inbound.id,
    aws_security_group.internal_private.id,
    aws_security_group.jumpbox_in.id,
    aws_security_group.allow_all.id
  ]
  tags = {
    Name = "primary_network_interface"
  }
}
###########################################


# Elastic IP
###########################################
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "bestbuy=${aws_subnet.private_1.availability_zone_id}"
  }
  depends_on = [aws_internet_gateway.igw]
}
###########################################


# EC2 Instances
###########################################
resource "aws_instance" "bastion_host" {
  ami = "ami-0e999cbd62129e3b1"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name

  network_interface {
    network_interface_id = aws_network_interface.jumpbox.id
    device_index = 0
  }
  tags = {
    Name = "bastion-host"
  }
}
resource "aws_instance" "web" {
  // https://aws.amazon.com/marketplace/server/configuration?productId=b7ee8a69-ee97-4a49-9e68-afaee216db2e
  ami = "ami-0bc06212a56393ee1"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name # change this later

  network_interface {
    network_interface_id = aws_network_interface.web.id
    device_index = 0
  }
  tags = {
    Name = "web-server"
  }
}
resource "aws_instance" "elastic" {
  ami = "ami-0bc06212a56393ee1"
  instance_type = "t3.medium"
  key_name = aws_key_pair.deployer.key_name # change this later

  network_interface {
    network_interface_id = aws_network_interface.elastic.id
    device_index = 0
  }
  tags = {
    Name = "elasticsearch"
  }
}
###########################################
