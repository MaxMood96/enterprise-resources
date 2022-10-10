locals {
  bucket_name = var.minio_bucket_name == "" ? local.random_name : var.minio_bucket_name
}
resource "google_storage_bucket" "minio" {
  name          = local.bucket_name
  location      = var.minio_bucket_location
  force_destroy = var.minio_bucket_force_destroy

  labels = var.resource_tags
}