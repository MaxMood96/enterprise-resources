output "minio_name" {
  value = google_storage_bucket.minio.name
}
output "postgres_username" {
  value = google_sql_user.codecov.name
}
output "postgres_server_name" {
  value = google_sql_database_instance.codecov.connection_name
}
output "postgres_pw" {
  value = google_sql_user.codecov.password
  sensitive = true
}
output "minio_secret_key" {
  value = google_storage_hmac_key.minio.secret
  sensitive = true
}
output "minio_access_key" {
  value = google_storage_hmac_key.minio.access_id
  sensitive = true
}
output "minio_domain" {
  value = google_storage_bucket.minio.name
}
output "postgres_ip" {
  value = google_sql_database_instance.codecov.private_ip_address
}
output "redis_port" {
  value = google_redis_instance.codecov.port
}
output "redis_hostname" {
  value = google_redis_instance.codecov.host
}
output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}
output "cluster_primary_endpoint" {
  value = google_container_cluster.primary.endpoint
}
output "google_project" {
  value = var.gcloud_project
}
output "nat_address" {
  value = google_compute_address.nat.address
}