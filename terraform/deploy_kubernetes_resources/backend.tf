data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../provision_vpc_and_eks/terraform.tfstate"
  }
}
