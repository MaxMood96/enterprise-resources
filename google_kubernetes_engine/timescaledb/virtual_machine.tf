resource "google_compute_instance" "timescale_db_server" {
  count        = var.timescale_server_replication_enabled == false ? 1 : 0
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    auto_delete = var.auto_delete
    initialize_params {
      image = "ubuntu-2204-jammy-v20221206"

    }
  }

  // Local SSD disk

  network_interface {
    network    = data.terraform_remote_state.cluster.outputs.network_name
    network_ip = google_compute_address.internal-address[count.index].address
    subnetwork = data.google_compute_subnetwork.my-subnetwork.name

  }


  metadata_startup_script = templatefile("../../modules/timescale_db/files/timescale_single_server.sh", {
    timescale_password = random_string.timescale.result
    prepend_userdata   = var.prepend_userdata
  })
  metadata = var.metadata

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}


resource "google_compute_firewall" "firewall" {
  count   = var.timescale_server_replication_enabled == false ? 1 : 0
  name    = "${var.name}-internal-firewall"
  network = data.terraform_remote_state.cluster.outputs.network_name
  allow {
    protocol = "tcp"
    ports    = concat(["22", "80", "443", "8404", "9243", "5432"])
  }
  allow {
    protocol = "ICMP"
  }
  source_ranges = var.source_inbound_ranges
  #target_tags   = [local.tag]
}

resource "google_compute_firewall" "internal" {
  count   = var.timescale_server_replication_enabled == false ? 1 : 0
  name    = "${var.name}-internal-traffic"
  network = data.terraform_remote_state.cluster.outputs.network_name

  direction = "INGRESS"
  allow {
    protocol = "all"
  }

  source_ranges = var.source_inbound_ranges
  #}
}

resource "google_compute_address" "internal-address" {
  count        = var.timescale_server_replication_enabled == false ? 1 : 0
  name         = "${var.name}-internal-ip"
  address_type = "INTERNAL"
  subnetwork   = data.google_compute_subnetwork.my-subnetwork.name
  region       = var.region
}


