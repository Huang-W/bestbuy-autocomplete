data "terraform_remote_state" "eks_web" {
  backend = "local"

  config = {
    path = "../provision_web_cluster/terraform.tfstate"
  }
}

data "terraform_remote_state" "eks_elastic" {
  backend = "local"

  config = {
    path = "../deploy_elastic_cluster_resources/terraform.tfstate"
  }
}
