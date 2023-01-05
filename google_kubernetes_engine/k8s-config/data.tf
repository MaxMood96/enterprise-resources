data "terraform_remote_state" "cluster" {
  backend = "local"
  config = {
    path = "../cluster/terraform.tfstate"
  }
}
data "terraform_remote_state" "timescaledb" {
  backend = "local"
  config = {
    path = "../timescaledb/terraform.tfstate"
  }
}
data "google_client_config" "current" {
}
