resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.pb1[var.subnet_availability_zones[0]].id

  tags = merge(local.common_tags, {
    Name = "bestbuy-nat1"
    Type = "infrastructure"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat-ip" {
  vpc = true
  tags = merge(local.common_tags, {
    Name = "nat1-ip"
    Type = "eip"
  })
}
