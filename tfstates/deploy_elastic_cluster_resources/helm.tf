# https://artifacthub.io/packages/helm/elastic/elasticsearch
resource "helm_release" "elastic" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.10.2"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  values = [
    <<EOF
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
EOF
  ]
  depends_on = [kubernetes_service_account.aws_load_balancer_controller]
}

// internal load balancer
data "kubernetes_service" "ilb" {
  metadata {
    name = "elasticsearch-master"
  }
  depends_on = [helm_release.elastic]
}
