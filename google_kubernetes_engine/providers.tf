provider "google" {
  project = var.gcloud_project
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
  host = "https://${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
  token = data.google_client_config.current.access_token
}