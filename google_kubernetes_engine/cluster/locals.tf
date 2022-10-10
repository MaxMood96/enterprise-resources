locals {
  random_name = "${var.name}-${random_pet.name.id}"
  location    = var.zonal_cluster_enabled ? var.zone : var.region
}

resource "random_pet" "name" {
  length    = "2"
  separator = "-"
}

