resource "kubernetes_deployment" "worker" {
  metadata {
    name        = "worker"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  spec {
    replicas = var.worker_resources["replicas"]
    selector {
      match_labels = {
        app = "worker"
      }
    }
    template {
      metadata {
        labels = {
          app = "worker"
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
          name  = "worker"
          image = "codecov/enterprise-worker:${var.codecov_version}"
          args  = ["worker", "--queue", "celery,uploads", "--concurrency", "1"]
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
              cpu    = var.worker_resources["cpu_limit"]
              memory = var.worker_resources["memory_limit"]
            }
            requests = {
              cpu    = var.worker_resources["cpu_request"]
              memory = var.worker_resources["memory_request"]
            }
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
    strategy {
      type = "RollingUpdate"
    }
  }
}

