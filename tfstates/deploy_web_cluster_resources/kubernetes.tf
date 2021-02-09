provider "aws" {
  region = data.terraform_remote_state.eks_web.outputs.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks_web.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks_web.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_web.outputs.eks_cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.terraform_remote_state.eks_web.outputs.cluster_id
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

resource "kubernetes_deployment" "node_web_deployment" {
  metadata {
    name = "node-deployment"
    labels = {
      name = "node-deployment"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        name = "node-pod"
      }
    }
    template {
      metadata {
        labels = {
          name = "node-pod"
        }
      }
      spec {
        container {
          name  = "bestbuy-web"
          image = replace("${data.terraform_remote_state.eks_web.outputs.ecr_url}/${data.terraform_remote_state.eks_web.outputs.ecr_repo_bestbuy}:1.0", "https://", "")
          image_pull_policy = "Always"
          env {
            name  = "DEPLOYMENT_TYPE"
            value = "ENV"
          }
          env {
            name  = "ES_ADDRESS"
            value = data.terraform_remote_state.eks_elastic.outputs.elastic_ilb_hostname
          }
          env {
            name  = "ES_PORT"
            value = 9200
          }
          env {
            name  = "WEB_PORT"
            value = 3000
          }
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "node_web_service" {
  metadata {
    name = "node-service"
  }
  spec {
    selector = {
      name = "node-pod"
    }
    port {
      port        = 8080
      target_port = 3000
    }
    type = "LoadBalancer"
  }
  depends_on = [kubernetes_deployment.node_web_deployment]
}
