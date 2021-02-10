data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../provision_vpc_and_eks/terraform.tfstate"
  }
}

data "terraform_remote_state" "eks_elastic" {
  backend = "local"

  config = {
    path = "../deploy_elastic_cluster_resources/terraform.tfstate"
  }
}
