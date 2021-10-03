resource "aws_vpc" "bestbuy-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(local.common_tags, {
    Name = "bestbuy-vpc"
    Type = "infrastructure"
  })
}

resource "aws_subnet" "pv1" {
  vpc_id               = aws_vpc.bestbuy-vpc.id
  for_each             = local.private_subnets
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = merge(local.common_tags, {
    Name                                        = "pv1-${each.key}"
    Type                                        = "infrastructure"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  })
}

resource "aws_subnet" "pb1" {
  vpc_id               = aws_vpc.bestbuy-vpc.id
  for_each             = local.public_subnets
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = merge(local.common_tags, {
    Name                                        = "pb1-${each.key}"
    Type                                        = "infrastructure"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  })
}

resource "aws_subnet" "elasticache" {
  vpc_id               = aws_vpc.bestbuy-vpc.id
  for_each             = local.elasticache_subnets
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = merge(local.common_tags, {
    Name = "elasticache-${each.key}"
    Type = "infrastructure"
  })
}
