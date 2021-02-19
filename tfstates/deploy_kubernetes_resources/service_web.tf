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
      "eks.amazonaws.com/role-arn" = data.terraform_remote_state.vpc.outputs.iam_load_balancer_controller_arn
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
          name              = "bestbuy-web"
          image             = replace("${data.terraform_remote_state.vpc.outputs.ecr_url}/${data.terraform_remote_state.vpc.outputs.ecr_repo_bestbuy}:init", "https://", "")
          image_pull_policy = "Always"
          env {
            name  = "DEPLOYMENT_TYPE"
            value = "ENV"
          }
          env {
            name  = "ELASTICSEARCH_ADDRESS"
            value = data.kubernetes_service.elastic.metadata.0.name
          }
          env {
            name  = "ELASTICSEARCH_PORT"
            value = 9200
          }
          env {
            name  = "WEB_PORT"
            value = 3000
          }
          env {
            name  = "REDIS_CACHING_ENABLED"
            value = "on"
          }
          env {
            name  = "REDIS_ADDRESS"
            value = data.terraform_remote_state.vpc.outputs.elasticache_endpoint
          }
          env {
            name  = "REDIS_PORT"
            value = 6379
          }
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

// application load balancer
resource "kubernetes_service" "node_web_service" {
  metadata {
    name = "node-service"
  }
  spec {
    selector = {
      name = "node-pod"
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
  depends_on = [kubernetes_deployment.node_web_deployment]
}
