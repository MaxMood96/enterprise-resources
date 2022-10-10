
output "lb_ip" {
  value = local.lb_ip
}
output "dns" {
  value = module.codecov.ingress_host
}