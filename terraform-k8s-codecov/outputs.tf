output "web_name" {
  value = kubernetes_service.web.metadata.0.name
}
output "lb_ip" {
  value = var.ingress_enabled ? kubernetes_ingress_v1.ingress[0].status[0]["load_balancer"][0]["ingress"][0]["ip"] : ""
}
output "ingress_host" {
  value = local.codecov_url
}
output "codecov_name" {
  value = kubernetes_secret.codecov-yml.metadata[0].name
}
output "namespace_name" {
  value = kubernetes_namespace.codecov[0].metadata[0].name
}
output "codecov_url" {
  value = local.codecov_url
}
