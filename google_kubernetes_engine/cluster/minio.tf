resource "random_pet" "minio-bucket-suffix" {
  length    = "2"
  separator = "-"
}
resource "google_storage_bucket" "minio" {
  name          = "${var.minio_bucket_name}-${random_pet.databases.id}"
  location      = var.minio_bucket_location
  force_destroy = var.minio_bucket_force_destroy

  labels = var.resource_tags
}
/*
resource "kubernetes_secret" "minio-access-key" {
  metadata {
    name        = "minio-access-key"
    annotations = var.resource_tags
  }
  data = {
    MINIO_ACCESS_KEY = google_storage_hmac_key.minio.access_id
  }
}

resource "kubernetes_secret" "minio-secret-key" {
  metadata {
    name        = "minio-secret-key"
    annotations = var.resource_tags
  }
  data = {
    MINIO_SECRET_KEY = google_storage_hmac_key.minio.secret
  }
*/