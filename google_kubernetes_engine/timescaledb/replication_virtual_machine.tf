resource "random_password" "timescale" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_compute_instance" "timescale_db_server_primary" {
  count        = var.timescale_server_replication_enabled ? 1 : 0
  name         = "${var.name}-primary"
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
    network_ip = google_compute_address.internal-address-replication[0].address
    subnetwork = data.google_compute_subnetwork.subnetwork.name

  }


  metadata_startup_script = templatefile("../../modules/timescale_db/files/timescale_replication_server_primary.sh", {
    MasterIP           = google_compute_address.internal-address-replication[0].address
    timescale_password = random_password.timescale.result
    stanza_name        = "db-primary"
    bucket             = google_storage_bucket.postgres_backups.name
    IP_RANGE           = var.subnet_range
    prepend_userdata   = var.prepend_userdata
    backups = templatefile("../../modules/timescale_db/files/pgbackrest.sh", {
      stanza_name = "db-primary"
      bucket      = google_storage_bucket.postgres_backups.name
    })
  })
  metadata = var.metadata

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = length(var.service_account_email) > 0 ? var.service_account_email : google_service_account.service_account[count.index].email
    scopes = ["cloud-platform"]
  }
  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_integrity_monitoring = var.enable_integrity_monitoring
    enable_vtpm                 = var.enable_vtpm
  }
}

resource "google_compute_instance" "timescale_db_server_secondary" {
  depends_on   = [google_compute_instance.timescale_db_server_primary]
  count        = var.timescale_server_replication_enabled ? 1 : 0
  name         = "${var.name}-secondary"
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
    network_ip = google_compute_address.internal-address-replication[1].address
    subnetwork = data.google_compute_subnetwork.subnetwork.name

  }


  metadata_startup_script = templatefile("../../modules/timescale_db/files/timescale_replication_server_secondary.sh", {
    MasterIP           = google_compute_address.internal-address-replication[0].address
    prepend_userdata   = var.prepend_userdata
    timescale_password = random_password.timescale.result

  })
  metadata = var.metadata

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = length(var.service_account_email) > 0 ? var.service_account_email : google_service_account.service_account[count.index].email
    scopes = ["cloud-platform"]
  }
  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_integrity_monitoring = var.enable_integrity_monitoring
    enable_vtpm                 = var.enable_vtpm
  }
}


resource "google_compute_firewall" "firewall-replication" {
  count   = length(var.source_inbound_ranges) > 0 ? 1 : 0
  name    = "${var.name}-sourceips-firewall"
  network = data.terraform_remote_state.cluster.outputs.network_name
  allow {
    protocol = "tcp"
    ports    = concat(["22", "80", "443", "8404", "9243", "5432"])
  }
  allow {
    protocol = "ICMP"
  }
  source_ranges = compact(concat(var.source_inbound_ranges, ["35.231.233.196"]))
  #target_tags   = [local.tag]
}
resource "google_compute_firewall" "firewall-pods_cidr" {
  count   = var.timescale_server_replication_enabled ? 1 : 0
  name    = "${var.name}-internal-firewall"
  network = data.terraform_remote_state.cluster.outputs.network_name
  allow {
    protocol = "tcp"
    ports    = concat(["5432"])
  }
  allow {
    protocol = "ICMP"
  }
  source_ranges = [data.terraform_remote_state.cluster.outputs.pod_cidr]
}


resource "google_compute_address" "internal-address-replication" {
  count        = var.timescale_server_replication_enabled ? 2 : 1
  name         = "${var.name}-internal-ip-${count.index}"
  address_type = "INTERNAL"
  subnetwork   = data.google_compute_subnetwork.subnetwork.name
  region       = var.region
}


