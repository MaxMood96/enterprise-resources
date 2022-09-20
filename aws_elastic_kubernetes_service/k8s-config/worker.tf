/*resource "kubernetes_deployment" "worker" {
  metadata {
    name        = "worker"
    annotations = var.resource_tags
    namespace   = var.codecov_namespace
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
        node_selector = {
          "role" = "worker"
        }
        service_account_name = kubernetes_service_account.codecov.metadata[0].name
        volume {
          name = kubernetes_service_account.codecov.default_secret_name
          secret {
            secret_name = kubernetes_service_account.codecov.default_secret_name
          }
        }
        volume {
          name = "codecov-yml"
          secret {
            secret_name = kubernetes_secret.codecov-yml.metadata[0].name
          }
        }
        volume {
          name = "scm-ca-cert"
          secret {
            secret_name = kubernetes_secret.scm-ca-cert.metadata[0].name
          }
        }
        container {
          name  = "worker"
          image = "codecov/enterprise-worker:${var.codecov_version}"
          args  = ["worker", "--queue celery,uploads", "--concurrency 1"]
          dynamic "env" {
            for_each = var.statsd_enabled || var.metrics_enabled ? { host = true } : {}
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
            for_each = var.statsd_enabled || var.metrics_enabled ? { host = true } : {}
            content {
              name  = "STATSD_PORT"
              value = "8125"
            }
          }
          env {
            name  = "SERVICES__DATABASE_URL"
            value = local.postgres_url
          }
          env {
            name  = "SERVICES__REDIS_URL"
            value = local.redis_url
          }
          dynamic "env" {
            for_each = local.minio_envs
            content {
              name  = env.key
              value = env.value
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.minio-creds.metadata.0.name
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
          volume_mount {
            name       = "scm-ca-cert"
            read_only  = "true"
            mount_path = "/cert"
          }

          # when using terraform, you must explicitly mount the service account secret volume
          # https://github.com/kubernetes/kubernetes/issues/27973
          # https://github.com/terraform-providers/terraform-provider-kubernetes/issues/38
          volume_mount {
            name       = kubernetes_service_account.codecov.default_secret_name
            read_only  = "true"
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }
        }
      }
    }
    strategy {
      type = "RollingUpdate"
    }
  }
  lifecycle {
    ignore_changes = [spec.0.template.0.spec.0.volume, spec.0.template.0.spec.0.container.0.volume_mount]
  }
  timeouts {
    create = "300s"
  }
}
*/