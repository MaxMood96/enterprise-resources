resource "random_id" "minio-bucket-suffix" {
  byte_length = "2"
}

resource "azurerm_storage_account" "minio" {
  name                     = "codecov${random_id.minio-bucket-suffix.hex}"
  resource_group_name      = azurerm_resource_group.codecov-enterprise.name
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  location                 = var.location
}

resource "kubernetes_secret" "minio-access-key" {
  metadata {
    name = "minio-access-key"
  }
  data = {
    MINIO_ACCESS_KEY = azurerm_storage_account.minio.name
  }
}

resource "kubernetes_secret" "minio-secret-key" {
  metadata {
    name = "minio-secret-key"
  }
  data = {
    MINIO_SECRET_KEY = azurerm_storage_account.minio.primary_access_key
  }
}

resource "kubernetes_deployment" "minio_storage" {
  metadata {
    name = "minio"
  }
  spec {
    replicas = var.minio_resources["replicas"]
    selector {
      match_labels = {
        app = "minio-storage"
      }
    }
    template {
      metadata {
        labels = {
          app = "minio-storage"
        }
      }
      spec {
        container {
          name  = "minio"
          image = "minio/minio:RELEASE.2020-04-15T00-39-01Z"
          args  = ["gateway", "azure"]
          port {
            container_port = 9000
          }
          env {
            name = "MINIO_ACCESS_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.minio-access-key.metadata[0].name
                key  = "MINIO_ACCESS_KEY"
              }
            }
          }
          env {
            name = "MINIO_SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.minio-secret-key.metadata[0].name
                key  = "MINIO_SECRET_KEY"
              }
            }
          }
          resources {
            limits = {
              cpu    = var.minio_resources["cpu_limit"]
              memory = var.minio_resources["memory_limit"]
            }
            requests = {
              cpu    = var.minio_resources["cpu_request"]
              memory = var.minio_resources["memory_request"]
            }
          }
          liveness_probe {
            http_get {
              path = "/minio/health/live"
              port = "9000"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
          readiness_probe {
            http_get {
              path = "/minio/health/live"
              port = "9000"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_service" "minio" {
  metadata {
    name = "minio"
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 9000
      target_port = "9000"
    }
    selector = {
      app = "minio-storage"
    }
  }
}

