provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  ignore_tags {
    # ignore any state-changes due to eks-related tags assigned in the upper modules
    key_prefixes = ["kubernetes.io/cluster/"]
  }
}

# Kubernetes provider
# https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes

# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.

provider "kubernetes" {
  alias = "elastic"
  host                   = data.aws_eks_cluster.elastic.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.elastic.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.eks_elastic
    ]
  }
}
data "aws_eks_cluster" "elastic" {
  name = module.eks_elastic.cluster_id
}
data "aws_eks_cluster_auth" "elastic" {
  name = module.eks_elastic.cluster_id
}

provider "kubernetes" {
  alias = "web"
  host                   = data.aws_eks_cluster.web.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.web.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.eks_web
    ]
  }
}
data "aws_eks_cluster" "web" {
  name = module.eks_web.cluster_id
}
data "aws_eks_cluster_auth" "web" {
  name = module.eks_web.cluster_id
}
