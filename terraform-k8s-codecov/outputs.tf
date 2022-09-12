output "web_name" {
  value = kubernetes_service.web.metadata.0.name
}
output "lb_ip" {
  value = kubernetes_ingress_v1.ingress[0].status[0]["load_balancer"][0]["ingress"][0]["ip"]
}