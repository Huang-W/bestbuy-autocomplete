resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bestbuy_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "bestbuy-subnets"
    Network = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.bestbuy_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "bestbuy-subnets"
    Network = "private"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}
/**
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}
*/
resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}
/**
resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.private.id
}
*/
