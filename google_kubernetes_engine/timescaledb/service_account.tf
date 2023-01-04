resource "google_service_account" "service_account" {
  count        = length(var.service_account_email) == 0 ? 1 : 0
  account_id   = "${var.name}-sa"
  display_name = "${var.name}-sa"
}

resource "google_service_account_key" "service_account_key" {
  count              = length(var.service_account_email) == 0 ? 1 : 0
  service_account_id = google_service_account.service_account[count.index].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket_iam_binding" "binding" {
  count  = length(var.service_account_email) == 0 ? 1 : 0
  bucket = google_storage_bucket.postgres_backups.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.service_account[count.index].email}",
  ]
}
