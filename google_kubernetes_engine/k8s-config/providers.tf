provider "google" {
  project = data.terraform_remote_state.cluster.outputs.google_project
  region  = var.region
}
provider "google" {
  project     = local.dns_project
  region      = local.dns_region
  alias       = "dns"
  credentials = "/Users/trent/development/codecov/dev.json"
}

provider "kubernetes" {
  host = "https://${data.terraform_remote_state.cluster.outputs.cluster_primary_endpoint}"
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.cluster_ca_certificate,
  )
  token = data.google_client_config.current.access_token
}