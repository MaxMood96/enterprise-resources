resource "kubernetes_deployment" "gateway" {
  metadata {
    name        = "gateway"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  spec {
    replicas = var.gateway_resources["replicas"]
    selector {
      match_labels = {
        app = "gateway"
      }
    }
    template {
      metadata {
        labels = {
          app = "gateway"
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
          name  = "gateway"
          image = "${var.codecov_repository}/${var.gateway_image}:${var.codecov_version}"
          port {
            container_port = 8000
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
              cpu    = var.gateway_resources["cpu_limit"]
              memory = var.gateway_resources["memory_limit"]
            }
            requests = {
              cpu    = var.gateway_resources["cpu_request"]
              memory = var.gateway_resources["memory_request"]
            }
          }
          readiness_probe {
            http_get {
              path = "/gateway_health"
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

resource "kubernetes_service" "gateway" {
  metadata {
    name        = "gateway"
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
      app = "gateway"
    }
  }
  lifecycle {
    ignore_changes = [metadata.0.annotations]
  }
}
