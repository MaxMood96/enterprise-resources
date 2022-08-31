resource "kubernetes_stateful_set" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "grafana"
      }
    }
    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }
      spec {
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.grafana.metadata.0.name
          }
        }
        volume {
          name = "dashboards"
          config_map {
            name = kubernetes_config_map.grafana_dashboards.metadata.0.name
          }
        }
        volume {
          name = "datasources"
          config_map {
            name = kubernetes_config_map.grafana_datasources.metadata.0.name
          }
        }
        security_context {
          run_as_group = "472"
          run_as_user  = "472"
          fs_group     = "472"
        }
        container {
          name              = "grafana"
          image             = var.grafana_image
          image_pull_policy = var.image_pull_policy
          port {
            container_port = 3000
          }
          env {
            name  = "GF_SERVER_ROOT_URL"
            value = "${var.scheme}://${var.url}/grafana"
          }
          env {
            name  = "GF_SERVER_SERVE_FROM_SUB_PATH"
            value = "true"
          }
          env {
            name  = "GRAFANA_PORT"
            value = "3000"
          }
          env {
            name  = "GF_AUTH_ANONYMOUS_ENABLED"
            value = "false"
          }
          env {
            name  = "GF_AUTH_ANONYMOUS_ORG_ROLE"
            value = "Admin"
          }
          env {
            name = "GF_SECURITY_ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.grafana.metadata.0.name
                key  = "password"
              }
            }
          }
          env {
            name = "GF_SECURITY_ADMIN_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.grafana.metadata.0.name
                key  = "user"
              }
            }
          }
          volume_mount {
            mount_path = "/var/lib/grafana"
            name       = "data"
          }
          volume_mount {
            mount_path = "/etc/grafana/provisioning/dashboards"
            name       = "dashboards"
          }
          volume_mount {
            mount_path = "/etc/grafana/provisioning/datasources"
            name       = "datasources"
          }
          readiness_probe {
            http_get {
              path   = "/api/health"
              port   = "3000"
              scheme = "HTTP"
            }
            timeout_seconds   = 1
            period_seconds    = 10
            success_threshold = 1
            failure_threshold = 3
          }
        }
        restart_policy = "Always"
      }
    }
    service_name = "grafana"
  }
  depends_on = [kubernetes_namespace.ns]
  timeouts {
    create = "50s"
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name        = "grafana"
    namespace   = var.namespace
    annotations = var.annotations
  }
  spec {
    port {
      port        = 3000
      name        = "tcp"
      protocol    = "TCP"
      target_port = 3000
    }
    selector = {
      app = "grafana"
    }
    type = var.load_balancer_type
  }
}

resource "kubernetes_persistent_volume_claim" "grafana" {
  metadata {
    name      = "grafana-data"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.grafana_disk_size
      }
    }
    storage_class_name = var.storage_class_name
  }
}

resource "random_password" "grafana" {
  count  = length(var.grafana_password) > 0 ? 0 : 1
  length = 32
}

locals {
  graf_pw = length(var.grafana_password) > 0 ? var.grafana_password : random_password.grafana[0].result
  datasources = templatefile("${path.module}/files/grafana_datasources.yml", {
    prom_user = "prometheus",
    prom_pw   = nonsensitive(local.prom_pw)
  })
  dashboards = file("${path.module}/files/codecov_dashboard.json")
}

resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana-initial-credentials"
    namespace = var.namespace
  }
  data = {
    user     = "admin"
    password = local.graf_pw
  }
}

resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name        = "grafana-dashboards-${md5(local.dashboards)}"
    namespace   = var.namespace
    annotations = var.annotations
  }
  data = {
    "dashboards.yml" = file("${path.module}/files/grafana_dashboards.yml")
    "codecov.json"   = local.dashboards
  }
  depends_on = [kubernetes_namespace.ns]
}

resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name        = "grafana-datasources-${md5(local.datasources)}"
    namespace   = var.namespace
    annotations = var.annotations
  }
  data = {
    "datasources.yml" = local.datasources
  }
  depends_on = [kubernetes_namespace.ns]
}