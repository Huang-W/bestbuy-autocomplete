
# Public Subnets
###########################################
resource "aws_subnet" "public_1" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  cidr_block           = "10.1.0.0/24"
  availability_zone_id = "usw2-az1"
  map_public_ip_on_launch = true
  tags = {
    Name = "bestbuy"
    Network = "public"
  }
}
/**
resource "aws_subnet" "public_2" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  cidr_block           = "10.1.1.0/24"
  availability_zone_id = "usw2-az2"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_3" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  cidr_block           = "10.1.2.0/24"
  availability_zone_id = "usw2-az3"
  map_public_ip_on_launch = true
}
*/
###########################################


# Private subnets
###########################################
resource "aws_subnet" "private_1" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  cidr_block           = "10.1.3.0/24"
  availability_zone_id = "usw2-az1"
  tags = {
    Name = "bestbuy"
    Network = "private"
  }
}
/**
resource "aws_subnet" "private_2" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  cidr_block           = "10.1.4.0/24"
  availability_zone_id = "usw2-az2"
}
resource "aws_subnet" "private_3" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  cidr_block           = "10.1.5.0/24"
  availability_zone_id = "usw2-az3"
}
*/
###########################################
