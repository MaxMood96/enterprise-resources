resource "google_compute_instance" "timescale_db_server" {
  count        = var.timescale_server_replication_enabled == false ? 1 : 0
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


  metadata_startup_script = templatefile("../../modules/timescale_db/files/timescale_single_server.sh", {
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