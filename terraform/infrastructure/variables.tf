variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "eks_subnets" {
  type = list(string)
}

variable "elasticache_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "subnet_availability_zones" {
  type = list(string)
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Environment = "bestbuy"
    Type        = "infrastructure"
  }
  private_subnets     = zipmap(var.subnet_availability_zones, var.private_subnets)
  public_subnets      = zipmap(var.subnet_availability_zones, var.public_subnets)
  elasticache_subnets = zipmap(var.subnet_availability_zones, var.elasticache_subnets)
  eks_subnets         = zipmap(var.subnet_availability_zones, var.eks_subnets)
}
