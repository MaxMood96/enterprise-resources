## Google Kubernetes Engine cluster and Node pool

## Cluster ##
# 
# It is recommended to avoid using the default node pool with terraform
# because some node pool changes will force recreation of the cluster.
# See the terraform docs for more info:
# https://www.terraform.io/docs/providers/google/r/container_cluster.html

data "google_container_engine_versions" "gke" {
  location = var.region
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  min_master_version = data.google_container_engine_versions.gke.latest_master_version

  ip_allocation_policy {
  }

  network = google_compute_network.codecov.name

  private_cluster_config {
    enable_private_nodes    = "true"
    enable_private_endpoint = "false"
    master_ipv4_cidr_block  = "10.254.0.0/28"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = "true"
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }

  resource_labels = var.resource_tags

  lifecycle {
    ignore_changes = [
      master_auth[0].client_certificate_config[0].issue_client_certificate,
      network,
    ]
  }
}

resource "google_container_node_pool" "web" {
  name       = "web"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.web_node_pool_count

  node_config {
    labels = merge({
      role = "web"
      },
      var.resource_tags
    )

    preemptible  = true
    machine_type = var.node_pool_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "worker" {
  name       = "worker"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.worker_node_pool_count

  node_config {
    labels = merge({
      role = "worker"
      },
      var.resource_tags
    )

    preemptible  = true
    machine_type = var.node_pool_worker_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

# Grabs the google client config in order to auth the kubernetes provider
data "google_client_config" "current" {
}
