# https://artifacthub.io/packages/helm/elastic/elasticsearch
resource "helm_release" "elastic" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.10.2"
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  depends_on = [kubernetes_service_account.aws_load_balancer_controller]
}

data "kubernetes_service" "elastic" {
  metadata {
    name = "elasticsearch-master"
  }
  depends_on = [helm_release.elastic]
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
          image   = replace("${data.terraform_remote_state.vpc.outputs.ecr_url}/${data.terraform_remote_state.vpc.outputs.ecr_repo_elastic}:init", "https://", "")
          command = ["/go/bin/es-indexer", "-addr=http://${data.kubernetes_service.elastic.metadata.0.name}:9200"]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit              = 3 # retry 3 times before failure
    ttl_seconds_after_finished = 0 # remove pod upon job completion
  }
  timeouts {
    create = "2m"
  }
  depends_on = [helm_release.elastic]
}
