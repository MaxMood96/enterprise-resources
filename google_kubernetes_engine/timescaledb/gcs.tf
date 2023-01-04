resource "google_storage_bucket" "postgres_backups" {
  name          = "${var.name}-backups"
  location      = var.storage_account_region
  force_destroy = true
  versioning {
    enabled = false
  }
  uniform_bucket_level_access = true

}