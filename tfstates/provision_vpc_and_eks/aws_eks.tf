###############################################################
# EKS - Elasticsearch
###############################################################
module "eks_elastic" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"
  providers = {
    kubernetes = kubernetes.elastic
  }

  cluster_name                = var.eks_elastic
  cluster_version             = "1.18"
  subnets                     = module.vpc.private_subnets
  vpc_id                      = module.vpc.vpc_id

  # attach_worker_cni_policy = false
  # enable_irsa = true

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "eks_elastic_nodes"
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 3
      asg_max_size                  = 5
      asg_min_size                  = 3
      key_name                      = module.key_pair_elastic.this_key_pair_key_name
      additional_security_group_ids = [module.elastic_node_sg.this_security_group_id]
    }
  ]
}
###############################################################


###############################################################
# EKS - Web Servers
###############################################################
module "eks_web" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"
  providers = {
    kubernetes = kubernetes.web
  }

  cluster_name    = var.eks_web
  cluster_version = "1.18"
  subnets                     = module.vpc.private_subnets
  vpc_id                      = module.vpc.vpc_id

  # attach_worker_cni_policy = false
  # enable_irsa = true

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "eks_web_nodes"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 1
      asg_max_size                  = 3
      asg_min_size                  = 1
      key_name                      = module.key_pair_web.this_key_pair_key_name
      additional_security_group_ids = [module.web_node_sg.this_security_group_id]
    }
  ]
}
###############################################################
