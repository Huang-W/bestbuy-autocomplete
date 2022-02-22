resource "aws_vpc" "bestbuy_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(local.common_tags, {
    Name = "bestbuy_vpc"
    Type = "infrastructure"
  })
}

output "bestbuy_vpc_id" {
  value = aws_vpc.bestbuy_vpc.id
}

output "bestbuy_vpc_cidr_block" {
  value = aws_vpc.bestbuy_vpc.cidr_block
}

resource "aws_subnet" "pv1" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  for_each             = local.private_subnets
  cidr_block           = each.value
  availability_zone_id = each.key

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

  tags = merge(local.common_tags, {
    Name                                        = "pv1-${each.key}"
    Type                                        = "infrastructure"
    "kubernetes.io/role/elb"                    = "1"
  })
}

output "pv1_subnet_ids" {
  value = values(aws_subnet.pv1)[*].id
}

resource "aws_subnet" "pb1" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  for_each             = local.public_subnets
  cidr_block           = each.value
  availability_zone_id = each.key

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

  tags = merge(local.common_tags, {
    Name                                        = "pb1-${each.key}"
    Type                                        = "infrastructure"
    "kubernetes.io/role/elb"                    = "1"
  })
}

output "pb1_subnet_ids" {
  value = values(aws_subnet.pb1)[*].id
}

resource "aws_subnet" "elasticache" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  for_each             = local.elasticache_subnets
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = merge(local.common_tags, {
    Name = "elasticache-${each.key}"
    Type = "infrastructure"
  })
}

output "elasticache_subnet_ids" {
  value = values(aws_subnet.elasticache)[*].id
}

resource "aws_subnet" "eks" {
  vpc_id               = aws_vpc.bestbuy_vpc.id
  for_each             = local.eks_subnets
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = merge(local.common_tags, {
    Name = "eks-${each.key}"
    Type = "infrastructure"
  })
}

output "eks_subnet_ids" {
  value = values(aws_subnet.eks)[*].id
}
