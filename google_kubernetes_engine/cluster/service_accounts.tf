resource "google_service_account" "postgres" {
  account_id   = "codecov-postgres"
  display_name = "Codecov postgres"
}

resource "google_service_account_key" "postgres" {
  service_account_id = google_service_account.postgres.name
}

resource "google_project_iam_member" "postgres" {
  project = var.gcloud_project
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.postgres.email}"
}

resource "google_service_account" "minio" {
  account_id   = "codecov-minio"
  display_name = "Codecov minio"
}

resource "google_service_account_key" "minio" {
  service_account_id = google_service_account.minio.name
}

resource "google_storage_hmac_key" "minio" {
  service_account_email = google_service_account.minio.email
}

resource "google_project_iam_custom_role" "storage_create" {
  role_id     = replace("${var.name}storage_create", "-", "_")
  title       = "Storage permissions for ${var.name}"
  permissions = ["storage.buckets.create"]
}

resource "google_project_iam_member" "storage" {
  project = var.gcloud_project
  role    = google_project_iam_custom_role.storage_create.name
  member  = "serviceAccount:${google_service_account.minio.email}"
}

resource "google_storage_bucket_iam_member" "minio" {
  bucket = google_storage_bucket.minio.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.minio.email}"
}
