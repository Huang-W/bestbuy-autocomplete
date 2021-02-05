data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../provision_elastic_cluster/terraform.tfstate"
  }
}
