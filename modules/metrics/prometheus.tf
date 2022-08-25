resource "kubernetes_stateful_set" "prom" {
  metadata {
    name        = "prometheus"
    namespace   = var.namespace
    annotations = var.annotations
  }
  spec {
    selector {
      match_labels = {
        app = "prometheus"
      }
    }
    template {
      metadata {
        labels = {
          app = "prometheus"
        }
      }
      spec {
        container {
          name = "prometheus"
          env {
            name = "THIS_POD_IP"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }
          args = [
            "--config.file=/config/prometheus.yml",
            "--web.config.file=/config/web.yml",
            "--log.level=debug",
            "--web.listen-address=:9090",
            "--web.external-url=/prometheus/",
            "--web.page-title='Prometheus'"
          ]
          image             = var.prometheus_image
          image_pull_policy = var.image_pull_policy
          port {
            container_port = 9090
          }
          volume_mount {
            mount_path = "/config"
            name       = "prometheus-config"
          }
          volume_mount {
            mount_path = "/data"
            name       = "data"
          }
        }
        restart_policy = "Always"
        volume {
          config_map {
            name = "prometheus-config-${md5(local.prom_config)}"
          }
          name = "prometheus-config"
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.prometheus.metadata.0.name
          }
        }
      }
    }
    service_name = "prometheus"
  }
  depends_on = [kubernetes_namespace.ns, kubernetes_config_map.prometheus]
}

locals {
  prom_config_obj = merge({
    global = {
      scrape_interval     = "15s"
      evaluation_interval = "15s"
    }
    scrape_configs = concat([{
      job_name     = "prometheus"
      metrics_path = "/prometheus/metrics"
      basic_auth = {
        username = "prometheus"
        password = local.prom_pw
      }
      static_configs = [{
        targets = ["localhost:9090"]

      }]
      }, {
      job_name = "statsd_metrics"
      static_configs = [{
        targets = ["statsd:9102"]
      }]
    }], var.prometheus_scrape_configs)
  }, var.extra_prometheus_config)
  prom_config = yamlencode(local.prom_config_obj)
  prom_web_config_obj = merge({
    basic_auth_users = {
      "${var.prometheus_user}" = bcrypt_hash.prometheus.id
    }
  }, var.extra_prometheus_web_config)
  prom_web_config = yamlencode(local.prom_web_config_obj)
}
resource "kubernetes_config_map" "prometheus" {
  metadata {
    name        = "prometheus-config-${md5(local.prom_config)}"
    namespace   = var.namespace
    annotations = var.annotations
  }
  data = {
    "prometheus.yml" = local.prom_config
    "web.yml"        = local.prom_web_config
  }
  depends_on = [kubernetes_namespace.ns]
}

resource "kubernetes_service" "prometheus" {
  metadata {
    name        = "prometheus"
    namespace   = var.namespace
    annotations = var.annotations
  }
  spec {
    port {
      port        = 9090
      name        = "tcp"
      protocol    = "TCP"
      target_port = 9090
    }
    selector = {
      app = "prometheus"
    }
    type = var.load_balancer_type
  }
  depends_on = [kubernetes_namespace.ns]
}

resource "random_password" "prometheus" {
  count  = length(var.prometheus_password) > 0 ? 0 : 1
  length = 32
}

locals {
  prom_pw = length(var.prometheus_password) > 0 ? var.prometheus_password : random_password.prometheus[0].result
}

resource "bcrypt_hash" "prometheus" {
  cleartext = local.prom_pw
}

resource "kubernetes_secret" "prometheus" {
  metadata {
    name      = "prometheus-initial-credentials"
    namespace = var.namespace
  }
  data = {
    user     = "prometheus"
    password = local.prom_pw
  }
}

resource "kubernetes_persistent_volume_claim" "prometheus" {
  metadata {
    name      = "prometheus-data"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.prometheus_disk_size
      }
    }
    storage_class_name = var.storage_class_name
  }
}