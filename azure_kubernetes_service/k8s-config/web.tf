resource "kubernetes_deployment" "web" {
  metadata {
    name        = "web"
    annotations = var.resource_tags
  }
  spec {
    replicas = var.web_resources["replicas"]
    selector {
      match_labels = {
        app = "web"
      }
    }
    template {
      metadata {
        labels = {
          app = "web"
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
          name  = "web"
          image = "codecov/enterprise-web:${var.codecov_version}"
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
          env {
            name  = "SERVICES__MINIO__HOST"
            value = "minio"
          }
          env {
            name  = "SERVICES__MINIO__PORT"
            value = "9000"
          }
          env {
            name = "SERVICES__MINIO__ACCESS_KEY_ID"
            value_from {
              secret_key_ref {
                name = data.terraform_remote_state.cluster.outputs.minio_access_key_name
                key  = "MINIO_ACCESS_KEY"
              }
            }
          }
          env {
            name = "SERVICES__MINIO__SECRET_ACCESS_KEY"
            value_from {
              secret_key_ref {
                name = data.terraform_remote_state.cluster.outputs.minio_secret_key_name
                key  = "MINIO_SECRET_KEY"
              }
            }
          }
          env {
            name  = "SERVICES__MINIO__BUCKET"
            value = data.terraform_remote_state.cluster.outputs.minio_name
          }
          resources {
            limits = {
              cpu    = var.web_resources["cpu_limit"]
              memory = var.web_resources["memory_limit"]
            }
            requests = {
              cpu    = var.web_resources["cpu_request"]
              memory = var.web_resources["memory_request"]
            }
          }
          readiness_probe {
            http_get {
              path = "/login"
              port = "5000"
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

resource "kubernetes_service" "web" {
  metadata {
    name        = "web"
    annotations = var.resource_tags
  }
  spec {
    port {
      protocol    = "TCP"
      port        = "5000"
      target_port = "5000"
    }
    selector = {
      app = "web"
    }
  }
}

resource "kubernetes_service" "web-external" {
  metadata {
    name = "web-external"
  }
  spec {
    selector = {
      app = "web"
    }
    port {
      port        = 80
      target_port = 5000
    }
    type = "LoadBalancer"
  }
}
