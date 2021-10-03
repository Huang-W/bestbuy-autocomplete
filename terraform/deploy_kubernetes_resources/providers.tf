terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

provider "helm" {
  kubernetes {
    # configuring the kubernetes provider using aws-iam-authenticator
    # https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider?in=terraform/kubernetes
    host                   = data.terraform_remote_state.vpc.outputs.eks_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.vpc.outputs.eks_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.vpc.outputs.cluster_name
      ]
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.vpc.outputs.eks_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.vpc.outputs.eks_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.vpc.outputs.cluster_name
    ]
  }
}
