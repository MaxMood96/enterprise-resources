resource "kubernetes_deployment" "api" {
  metadata {
    name        = "api"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  spec {
    replicas = var.api_resources["replicas"]
    selector {
      match_labels = {
        app = "api"
      }
    }
    template {
      metadata {
        labels = {
          app = "api"
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
        container {
          name  = "api"
          image = "codecov/enterprise-api:${var.codecov_version}"
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
            for_each = local.common_secret_env
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value.secret
                  key  = env.value.key
                }
              }
            }
          }
          dynamic "env_from" {
            for_each = local.enable_aws_minio_env_run_as
            content {
              secret_ref {
              name = "minio-creds"
            }
            }
          }
          resources {
            limits = {
              cpu    = var.api_resources["cpu_limit"]
              memory = var.api_resources["memory_limit"]
            }
            requests = {
              cpu    = var.api_resources["cpu_request"]
              memory = var.api_resources["memory_request"]
            }
          }
          readiness_probe {
            http_get {
              path = "/health/"
              port = "8000"
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

resource "kubernetes_service" "api" {
  metadata {
    name        = "api"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  spec {
    port {
      protocol    = "TCP"
      port        = "8000"
      target_port = "8000"
    }
    selector = {
      app = "api"
    }
  }
}
