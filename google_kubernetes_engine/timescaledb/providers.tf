provider "google" {
  project = data.terraform_remote_state.cluster.outputs.google_project
  region  = var.region
}