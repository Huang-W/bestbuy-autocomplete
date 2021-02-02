resource "aws_security_group" "http_outbound" {
  name        = "allow_http_out"
  description = "allow outbound http and tls"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bestbuy"
  }
}

resource "aws_security_group" "elastic_inbound" {
  name        = "allow_elastic_in"
  description = "for inbound http requests"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress {
    from_port   = 9200
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_1.cidr_block]
  }
  tags = {
    Name = "bestbuy"
  }
}

resource "aws_security_group" "http_inbound" {
  name        = "allow_http_in"
  description = "allow inbound http from public"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bestbuy"
  }
}

resource "aws_security_group" "internal_public" {
  name        = "allow_internal_public"
  description = "within the same subnets"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.public_1.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.public_1.cidr_block]
  }
}

resource "aws_security_group" "internal_private" {
  name        = "allow_internal_private"
  description = "within the same subnets"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private_1.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private_1.cidr_block]
  }
}

resource "aws_security_group" "ssh_inbound" {
  name        = "allow_ssh_in"
  description = "ssh in"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_home_network]
  }
}

resource "aws_security_group" "jumpbox_in" {
  name        = "ssh_from_jumpbox"
  description = "ssh from jumpbox"
  vpc_id      = aws_vpc.bestbuy_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [for s in aws_network_interface.jumpbox.private_ips : "${s}/32"]
  }
}

resource "aws_security_group" "allow_all" {
  name   = "allow_all"
  vpc_id = aws_vpc.bestbuy_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# https://aws.amazon.com/blogs/containers/de-mystifying-cluster-networking-for-amazon-eks-worker-nodes/
# https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
