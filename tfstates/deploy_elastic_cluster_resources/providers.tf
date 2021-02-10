provider "aws" {
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

provider "helm" {
  kubernetes {
    # configuring the kubernetes provider using aws-iam-authenticator
    # https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider?in=terraform/kubernetes
    host                   = data.terraform_remote_state.vpc.outputs.eks_elastic_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.vpc.outputs.eks_elastic_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.vpc.outputs.eks_elastic
      ]
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.vpc.outputs.eks_elastic_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.vpc.outputs.eks_elastic_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.vpc.outputs.eks_elastic
    ]
  }
}
