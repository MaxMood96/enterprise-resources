resource "google_redis_instance" "codecov" {
  name               = local.random_name
  tier               = "BASIC"
  memory_size_gb     = var.redis_memory_size
  authorized_network = google_compute_network.codecov.name
  labels             = var.resource_tags
  redis_version      = var.redis_version
  auth_enabled       = true
  location_id        = var.zone == "" ? null : var.zone
}

resource "google_sql_database_instance" "codecov" {
  name             = local.random_name
  database_version = var.postgres_version
  region           = var.region

  deletion_protection = var.deletion_protection
  settings {
    tier              = var.postgres_instance_type
    user_labels       = var.resource_tags
    availability_type = var.zonal_cluster_enabled ? "ZONAL" : "REGIONAL"
    ip_configuration {
      private_network = google_compute_network.codecov.id
    }
  }
  depends_on = [google_compute_global_address.private_ip_alloc]
}

resource "random_string" "postgres-password" {
  length  = "16"
  special = "false"
}

resource "google_sql_user" "codecov" {
  instance = google_sql_database_instance.codecov.name
  name     = "codecov"
  password = random_string.postgres-password.result
}

# Destroying this resource fails because GCP refuses to destroy user above
# while it still owns db resources.  For now, we have provided a destroy.sh script
# that removes the above user from state to allow the db instance to be destroyed.
resource "google_sql_database" "codecov" {
  name       = "codecov"
  instance   = google_sql_database_instance.codecov.name
  depends_on = [google_sql_user.codecov]
}

