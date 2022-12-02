resource "google_compute_instance" "timescale_db_server" {
  name         = "timescale-qa"
  machine_type = "e2-small"
  zone         = var.region

  tags = var.resource_tags

  boot_disk {
    source_image = "ubuntu-2004-focal-v20220204"
    auto_delete  = true
    boot         = true

  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = var.network_name
    network_ip = google_compute_address.internal-address.name

    access_config {
      // Ephemeral public IP
    }
  }


  metadata_startup_script = templatefile("timescale.sh")


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "firewall" {
  name    = "timescale-internal-firewall"
  network = var.network_name
  allow {
    protocol = "tcp"
    ports    = concat(["22", "80", "443", "8404", "9243"])
  }
  allow {
    protocol = "ICMP"
  }
  #source_ranges = [for k, v in module.config.data.vpn_regions : v.cidr]
  #target_tags   = [local.tag]
}

resource "google_compute_firewall" "internal" {
  name    = "timescale-internal-traffic"
  network = var.network_name

  direction = "INGRESS"
  allow {
    protocol = "all"
  }

  #source_ranges = concat([for e, r in module.config.data.bastion_cidr_range : r], local.cidr_ranges)
#}
}

resource "google_compute_address" "internal-address" {
  provider     = google-beta
  name         = "timescale-internal-ip"
  address_type = "INTERNAL"
  subnetwork   = var.subnet_name
  region       = var.region
}


