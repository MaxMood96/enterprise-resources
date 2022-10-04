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