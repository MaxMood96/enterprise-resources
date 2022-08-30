resource "kubernetes_deployment" "minio_storage" {
  metadata {
    name      = "minio"
    namespace = local.namespace
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
                name = kubernetes_secret.minio-secrets.metadata[0].name
                key  = "MINIO_ACCESS_KEY"
              }
            }
          }
          env {
            name = "MINIO_SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.minio-secrets.metadata[0].name
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
    name      = "minio"
    namespace = local.namespace
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

