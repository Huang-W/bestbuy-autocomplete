terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

variable "kube_config_path" {
  type    = string
  default = "~/.kube/config"
}

variable "kube_config_context_elastic" {
  type    = string
  default = "kind-bestbuy-elastic"
}

variable "kube_config_context_web" {
  type    = string
  default = "kind-bestbuy-web"
}

provider "docker" {}

provider "kubernetes" {
  alias = "elastic"
  config_path    = var.kube_config_path
  config_context = var.kube_config_context_elastic
}
provider "kubernetes" {
  alias = "web"
  config_path    = var.kube_config_path
  config_context = var.kube_config_context_web
}

provider "helm" {
  alias = "elastic"
  kubernetes {
    config_path    = var.kube_config_path
    config_context = var.kube_config_context_elastic
  }
}
provider "helm" {
  alias = "web"
  kubernetes {
    config_path    = var.kube_config_path
    config_context = var.kube_config_context_web
  }
}

resource "helm_release" "elastic" {
  provider = helm.elastic
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.10.2"
  set {
    name  = "sysctlInitContainer.enabled"
    value = false
  }
  set {
    name  = "antiAffinity"
    value = "soft"
  }
  set {
    name = "nodeGroup"
    value = "master"
  }
}

resource "kubernetes_deployment" "node_web_deployment" {
  provider = kubernetes.web
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
          image = "bestbuy-web:1.0"
          name = "bestbuy-web"
          env {
            name = "DEPLOYMENT_TYPE"
            value = "ENV"
          }
          env {
            name = "ES_ADDRESS"
            value = "bestbuy-elastic-control-plane"
          }
          env {
            name = "ES_PORT"
            value = 30080
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
  provider = kubernetes.web
  metadata {
    name = "node-service"
  }
  spec {
    selector = {
      name = "node-pod"
    }
    port {
      port = 3000
      target_port = 3000
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_deployment.node_web_deployment]
}

resource "helm_release" "elastic_ingress" {
  provider = helm.elastic
  name       = "elastic-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  set {
    name = "controller.service.type"
    value = "NodePort"
  }
  set {
    name = "controller.service.nodePorts.http"
    value = 30080
  }
  set {
    name = "controller.service.nodePorts.https"
    value = 30443
  }
}

resource "helm_release" "web_ingress" {
  provider = helm.web
  name       = "web-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  set {
    name = "controller.service.type"
    value = "NodePort"
  }
  set {
    name = "controller.service.nodePorts.http"
    value = 31080
  }
  set {
    name = "controller.service.nodePorts.https"
    value = 31443
  }
}

resource "kubernetes_ingress" "elastic_ingress" {
  provider = kubernetes.elastic
  metadata {
    name = "es-ingress"
  }
  spec {
    backend {
      service_name = "elasticsearch-master"
      service_port = 9200
    }
  }
  depends_on = [helm_release.elastic_ingress]
}

resource "kubernetes_ingress" "web_ingress" {
  provider = kubernetes.web
  metadata {
    name = "web-ingress"
  }
  spec {
    backend {
      service_name = "node-service"
      service_port = 3000
    }
  }
  depends_on = [helm_release.web_ingress, kubernetes_service.node_web_service]
}
