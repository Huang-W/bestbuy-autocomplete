output "elastic_ilb" {
  value = data.kubernetes_service.ilb.spec
}
