variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_name" {
  type    = string
  default = "bestbuy-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "elasticache_subnets" {
  type    = list(string)
  default = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
}

variable "my_home_network" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "bestbuy-autocomplete"
}

variable "azs" {
  type    = list(string)
  default = ["usw2-az1", "usw2-az2", "usw2-az3"]
}
