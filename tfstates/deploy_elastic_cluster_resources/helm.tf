provider "helm" {
  kubernetes {
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
}

# https://github.com/elastic/helm-charts/blob/7.10/elasticsearch/values.yaml
resource "helm_release" "elastic" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.10.2"
  set {
    name = "service.type"
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

data "kubernetes_service" "ilb" {
  metadata {
    name = "elasticsearch-ilb"
  }
}
