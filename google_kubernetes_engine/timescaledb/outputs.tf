
output "timescale_db_ip_primary" {
  value = var.timescale_server_replication_enabled ? google_compute_address.internal-address-replication[0].address : ""
}
output "timescale_db_ip_secondary" {
  value = var.timescale_server_replication_enabled ? google_compute_address.internal-address-replication[1].address : ""
}
output "timescale_url" {
  value     = "postgres://codecov:${random_password.timescale.result}@${google_compute_address.internal-address-replication[0].address}:5432"
  sensitive = true
}