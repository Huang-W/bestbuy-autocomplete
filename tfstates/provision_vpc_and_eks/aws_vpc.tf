module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name                    = "bestbuy-vpc"
  cidr                    = "10.1.0.0/16"
  azs                     = var.azs
  private_subnets         = var.vpc_private_subnets
  public_subnets          = var.vpc_public_subnets
  elasticache_subnets     = var.elasticache_subnets
  enable_nat_gateway      = true
  single_nat_gateway      = false
  one_nat_gateway_per_az  = true
  map_public_ip_on_launch = true

  # these tags allow the EKS clusters to discover these subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

# https://aws.amazon.com/blogs/containers/de-mystifying-cluster-networking-for-amazon-eks-worker-nodes/
# https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
