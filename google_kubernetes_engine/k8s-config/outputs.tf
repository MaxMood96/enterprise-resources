output "minio_host" {
  value = local.minio_domain
}
output "lb_ip" {
  value = module.codecov.lb_ip
}
output "dns" {
  value = module.codecov.ingress_host
}