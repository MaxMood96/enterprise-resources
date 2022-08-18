
output "ingress-lb-ip" {
  value = kubernetes_ingress_v1.ingress.status[0]["load_balancer"][0]["ingress"][0]["ip"]
}
output "ingress_host" {
  value = data.terraform_remote_state.cluster.outputs.codecov_url
}