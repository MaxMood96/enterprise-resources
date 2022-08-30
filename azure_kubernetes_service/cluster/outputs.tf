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

output "minio_primary_access_key" {
  sensitive = true
  value     = azurerm_storage_account.minio.primary_access_key
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

