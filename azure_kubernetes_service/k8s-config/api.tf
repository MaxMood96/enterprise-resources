resource "kubernetes_deployment" "api" {
  metadata {
    name        = "api"
    annotations = var.resource_tags
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
            secret_name = data.terraform_remote_state.cluster.outputs.codecov_name
          }
        }
        volume {
          name = "scm-ca-cert"
          secret {
            secret_name = data.terraform_remote_state.cluster.outputs.scm_ca_cert_name
          }
        }
        container {
          name  = "api"
          image = "codecov/enterprise-api:${var.codecov_version}"
          port {
            container_port = 5000
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
          env {
            name  = "SERVICES__DATABASE_URL"
            value = local.postgres_url
          }
          env {
            name  = "SERVICES__REDIS_URL"
            value = local.redis_url
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
              path = "/health"
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
          volume_mount {
            name       = "scm-ca-cert"
            read_only  = "true"
            mount_path = "/cert"
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
