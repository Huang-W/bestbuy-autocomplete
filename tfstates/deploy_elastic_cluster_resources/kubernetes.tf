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

// a one-off job to index and populate the elasticsearch cluster
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
          image   = replace("${data.terraform_remote_state.vpc.outputs.ecr_url}/${data.terraform_remote_state.vpc.outputs.ecr_repo_elastic}:1.0", "https://", "")
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
