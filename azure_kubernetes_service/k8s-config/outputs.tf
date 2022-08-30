
output "ingress-lb-ip" {
  value = local.lb_ip
}
output "ingress_host" {
  value = local.codecov_url
}
output "minio_host" {
  value = local.minio_domain
}
output "codecov_name" {
  value = kubernetes_secret.codecov-yml.metadata[0].name
}

output "codecov_url" {
  value = local.codecov_url
}