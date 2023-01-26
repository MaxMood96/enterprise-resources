resource "kubernetes_deployment" "frontend" {
  metadata {
    name        = "frontend"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  spec {
    replicas = var.frontend_resources["replicas"]
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        volume {
          name = "codecov-yml"
          secret {
            secret_name = kubernetes_secret.codecov-yml.metadata.0.name
          }
        }
        dynamic "volume" {
          for_each = var.extra_secret_volumes
          content {
            name = volume.key
            secret {
              secret_name = kubernetes_secret.extra[volume.key].metadata.0.name
            }
          }
        }
        service_account_name = kubernetes_service_account.codecov.metadata.0.name
        container {
          name  = "frontend"
          image = "${var.codecov_repository}/${var.frontend_image}:${var.codecov_version}"
          port {
            container_port = 8000
          }
          env {
            name  = "CODECOV_BASE_HOST"
            value = local.codecov_url
          }
          env {
            name  = "CODECOV_API_HOST"
            value = local.codecov_api_url
          }
          dynamic "env" {
            for_each = var.statsd_enabled ? { host = true } : {}
            content {
              name = "STATSD_HOST"
              value_from {
                field_ref {
                  field_path = "status.hostIP"
                }
              }
            }
          }
          dynamic "env" {
            for_each = var.statsd_enabled ? { host = true } : {}
            content {
              name  = "STATSD_PORT"
              value = "8125"
            }
          }
          dynamic "env" {
            for_each = local.common_env
            content {
              name  = env.key
              value = env.value
            }
          }
          dynamic "env" {
            for_each = local.secret_env
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value.secret
                  key  = env.key
                }
              }
            }
          }
          resources {
            limits = {
              cpu    = var.frontend_resources["cpu_limit"]
              memory = var.frontend_resources["memory_limit"]
            }
            requests = {
              cpu    = var.frontend_resources["cpu_request"]
              memory = var.frontend_resources["memory_request"]
            }
          }
          readiness_probe {
            http_get {
              path = "/"
              port = "8080"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
          image_pull_policy = "Always"
          volume_mount {
            name       = "codecov-yml"
            read_only  = "true"
            mount_path = "/config"
          }
          dynamic "volume_mount" {
            for_each = var.extra_secret_volumes
            content {
              name       = volume_mount.key
              read_only  = lookup(volume_mount.value, "read_only", "true")
              mount_path = volume_mount.value.mount_path
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name        = "frontend"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  spec {
    port {
      protocol    = "TCP"
      port        = "8080"
      target_port = "8080"
    }
    selector = {
      app = "frontend"
    }
  }
  lifecycle {
    ignore_changes = [metadata.0.annotations]
  }
}
