provider "google" {
  project = data.terraform_remote_state.cluster.outputs.google_project
  region  = var.region
  zone    = var.zone
}
provider "google" {
  project = data.terraform_remote_state.cluster.outputs.google_project
  region  = var.dns_region
  zone    = var.dns_zone
  alias   = "dns"
}

provider "kubernetes" {
  host = "https://${data.terraform_remote_state.cluster.outputs.cluster_primary_endpoint}"
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.cluster_ca_certificate,
  )
  token = data.google_client_config.current.access_token
}/*
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "kubectl" {
  # Configuration options
}*/