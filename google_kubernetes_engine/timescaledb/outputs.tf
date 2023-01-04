output "timescale_db_ip_single_server" {
  value = var.timescale_server_replication_enabled == false ? google_compute_address.internal-address[0].address : ""
}
output "timescale_db_ip_primary" {
  value = var.timescale_server_replication_enabled ? google_compute_address.internal-address-replication[0].address : ""
}
output "timescale_db_ip_secondary" {
  value = var.timescale_server_replication_enabled ? google_compute_address.internal-address-replication[1].address : ""
}