module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  # attach_worker_cni_policy = false
  # enable_irsa = true

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "eks_node_group"
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 3
      asg_max_size                  = 5
      asg_min_size                  = 3
      key_name                      = module.key_pair_eks.key_pair_key_name
      additional_security_group_ids = [module.node_sg.security_group_id]
    }
  ]
}
