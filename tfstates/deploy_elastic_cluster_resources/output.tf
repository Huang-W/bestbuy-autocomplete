output "elastic_ilb_hostname" {
  value = data.kubernetes_service.ilb.status[0].load_balancer[0].ingress[0].hostname
}
