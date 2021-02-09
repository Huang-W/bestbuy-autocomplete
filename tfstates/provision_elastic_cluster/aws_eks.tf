provider "aws" {
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

module "eks_elastic" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  cluster_name                = var.cluster_name
  cluster_version             = "1.18"
  subnets                     = data.terraform_remote_state.vpc.outputs.vpc_private_subnets
  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id

  # attach_worker_cni_policy = false
  # enable_irsa = true

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "eks_elastic_nodes"
      instance_type                 = "t2.medium"
      additional_security_group_ids = [module.elastic_node_sg.this_security_group_id]
      asg_desired_capacity          = 3
      asg_max_size                  = 5
      asg_min_size                  = 3
      key_name                      = module.key_pair.this_key_pair_key_name
    }
  ]
}

resource "random_pet" "this" {
  length = 2
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = random_pet.this.id
  public_key = tls_private_key.this.public_key_openssh
}
