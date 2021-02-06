/**
output "web_alb_hostname" {
  value = kubernetes_ingress.web_ingress.status[0].load_balancer[0].ingress[0].hostname
}
*/
