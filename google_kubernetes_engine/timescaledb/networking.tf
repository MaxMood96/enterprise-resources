/*resource "google_compute_subnetwork" "vm_subnetwork" {
  name                     = "${var.name}-subnet"
  ip_cidr_range            = var.subnet_range
  network                  = data.terraform_remote_state.cluster.outputs.network_name
  private_ip_google_access = true
  region                   = var.region
  #source_ranges = var.source_range

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.1
    metadata             = "INCLUDE_ALL_METADATA"
  }
}*/

data "google_compute_subnetwork" "my-subnetwork" {
  name   = data.terraform_remote_state.cluster.outputs.network_name
  region = var.region
}