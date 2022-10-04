resource "google_compute_network" "codecov" {
  name = "codecov-enterprise"
}

resource "google_compute_address" "nat" {
  name = "codecov-enterprise"
}

output "egress-ip" {
  value = google_compute_address.nat.address
}

resource "google_compute_router" "codecov" {
  name    = "codecov-enterprise"
  region  = var.region
  network = google_compute_network.codecov.name
}


resource "google_compute_router_nat" "nat" {
  name                               = "codecov-nat"
  router                             = google_compute_router.codecov.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  nat_ips = [
    google_compute_address.nat.self_link
  ]

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.codecov.id
}
resource "google_service_networking_connection" "nat_service" {
  network                 = google_compute_network.codecov.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
