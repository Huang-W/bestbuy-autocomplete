resource "aws_route_table" "pv1" {
  for_each = local.private_subnets
  vpc_id   = aws_vpc.bestbuy_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }

  tags = merge(local.common_tags, {
    Name = "pv1-${each.key}"
    Type = "infrastructure"
  })
  depends_on = [aws_nat_gateway.nat1]
}

resource "aws_route_table" "pb1" {
  for_each = local.public_subnets
  vpc_id   = aws_vpc.bestbuy_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "pb1"
    Type = "infrastructure"
  })
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "elasticache" {
  for_each = local.elasticache_subnets
  vpc_id   = aws_vpc.bestbuy_vpc.id

  tags = merge(local.common_tags, {
    Name = "pb1"
    Type = "infrastructure"
  })
  depends_on = [aws_internet_gateway.igw]
}
