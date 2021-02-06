provider "aws" {
  region = data.terraform_remote_state.eks.outputs.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks.outputs.cluster_id
    ]
  }
}

# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name = "aws-load-balancer-controller"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
    }
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller.arn
    }
  }
}

resource "kubernetes_job" "init_elastic" {
  metadata {
    name = "init-elasticsearch-index"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "go-runner"
          image   = replace("${data.terraform_remote_state.eks.outputs.ecr_url}/${data.terraform_remote_state.eks.outputs.ecr_repo_elastic}:1.0", "https://", "")
          command = ["/go/bin/es-indexer", "-addr=http://${data.kubernetes_service.ilb.status[0].load_balancer[0].ingress[0].hostname}:9200"]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 3
  }
  wait_for_completion = true
  depends_on          = [helm_release.elastic]
}
