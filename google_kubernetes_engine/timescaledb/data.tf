data "terraform_remote_state" "cluster" {
  backend = "local"
  config = {
    path = "../cluster/terraform.tfstate"
  }
}
data "google_client_config" "current" {
}

data "google_compute_subnetwork" "subnetwork" {
  name   = data.terraform_remote_state.cluster.outputs.network_name
  region = var.region
}