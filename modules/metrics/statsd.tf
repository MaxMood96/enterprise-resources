resource "kubernetes_daemonset" "statsd" {
  metadata {
    name        = "statsd"
    namespace   = var.namespace
    annotations = var.annotations
  }
  spec {
    selector {
      match_labels = {
        app = "statsd"
      }
    }
    template {
      metadata {
        labels = {
          app = "statsd"
        }
      }
      spec {
        container {
          name = "statsd"
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
            "--statsd.listen-udp=:8125",
            "--statsd.listen-tcp=:8125"
          ]
          image             = var.statsd_image
          image_pull_policy = var.image_pull_policy
          port {
            container_port = 8125
          }
          port {
            container_port = 9102
          }
        }
        host_network   = true
        restart_policy = "Always"
      }
    }
  }
  depends_on = [kubernetes_namespace.ns]
}

resource "kubernetes_service" "statsd" {
  metadata {
    name        = "statsd"
    namespace   = var.namespace
    annotations = var.annotations
  }
  spec {
    port {
      port        = 9102
      name        = "web"
      protocol    = "TCP"
      target_port = 9102
    }
    port {
      port        = 8125
      name        = "udp"
      protocol    = "UDP"
      target_port = 8125
    }
    port {
      port        = 8125
      name        = "tcp"
      protocol    = "TCP"
      target_port = 8125
    }
    selector = {
      app = "statsd"
    }
    type = var.load_balancer_type
  }
}