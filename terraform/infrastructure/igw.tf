resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bestbuy_vpc.id

  tags = merge(local.common_tags, {
    Name = "bestbuy-igw"
    Type = "infrastructure"
  })
}
