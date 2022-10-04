
output "lb_ip" {
  value = var.ingress_enabled ? data.terraform_remote_state.cluster.outputs.nat_address : module.codecov.lb_ip
}
output "dns" {
  value = module.codecov.ingress_host
}