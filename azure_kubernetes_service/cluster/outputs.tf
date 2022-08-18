output "postgres_username" {
  value = azurerm_postgresql_server.codecov.administrator_login
}
output "postgres_pw" {
  value     = azurerm_postgresql_server.codecov.administrator_login_password
  sensitive = true
}
output "postgres_server_name" {
  value = azurerm_postgresql_server.codecov.name
}
output "postgres_fqdn" {
  value = azurerm_postgresql_server.codecov.fqdn
}
output "redis_hostname" {
  value = azurerm_redis_cache.codecov.hostname
}
output "redis_port" {
  value = azurerm_redis_cache.codecov.port
}
output "minio_access_key_name" {
  value = kubernetes_secret.minio-access-key.metadata.0.name

}
output "scm_ca_cert_name" {
  value = kubernetes_secret.scm-ca-cert.metadata[0].name
}
output "minio_secret_key_name" {
  value = kubernetes_secret.minio-secret-key.metadata.0.name

}
output "codecov_name" {
  value = kubernetes_secret.codecov-yml.metadata[0].name
}
output "minio_name" {
  value = azurerm_storage_account.minio.name
}

output "kubeconfig_host" {
  value     = azurerm_kubernetes_cluster.codecov-enterprise.kube_config[0].host
  sensitive = true
}
output "kubeconfig_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.codecov-enterprise.kube_config[0].cluster_ca_certificate
  sensitive = true
}
output "kubeconfig_client_certificate" {
  value     = azurerm_kubernetes_cluster.codecov-enterprise.kube_config[0].client_certificate
  sensitive = true
}
output "kubeconfig_client_key" {
  value     = azurerm_kubernetes_cluster.codecov-enterprise.kube_config[0].client_key
  sensitive = true
}

output "codecov_url" {
  value = trimprefix(local.codecov_url["setup"]["codecov_url"], ("https://"))
}