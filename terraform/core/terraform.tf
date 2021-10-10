terraform {
  backend "s3" {
    bucket         = "bestbuy-us-west-2-terraform-remote-state"
    key            = "bestbuy/core/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locking"
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket         = "bestbuy-us-west-2-terraform-remote-state"
    key            = "bestbuy/infrastructure/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locking"
  }
}
