output "web_alb_hostname" {
  value = kubernetes_service.node_web_service.status[0].load_balancer[0].ingress[0].hostname
}
