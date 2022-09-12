resource "kubernetes_ingress_v1" "ingress" {
  count                  = var.ingress_enabled ? 1 : 0
  wait_for_load_balancer = true
  metadata {
    name      = "nginx-ingress"
    namespace = local.namespace
  }
  spec {
    ingress_class_name = "nginx"
    dynamic "tls" {
      for_each = local.enable_certmanager
      content {
        secret_name = "codecov-cert"
        hosts       = [local.codecov_url]
      }
    }
    dynamic "tls" {
      for_each = local.enable_certmanager
      content {
        secret_name = "minio-cert"
        hosts       = [local.minio_domain]
      }
    }
    dynamic "tls" {
      for_each = local.enable_external_tls
      content {
        secret_name = kubernetes_secret_v1.tls-secret[0].metadata[0].name
        hosts       = [local.codecov_url]
      }
    }
    rule {
      host = local.codecov_url
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.web.metadata.0.name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
    rule {
      host = local.minio_domain
      http {
        path {
          path = "/"
          backend {
            service {
              name = var.minio_name
              port {
                number = 9000
              }
            }
          }
        }
      }
    }
  }
  depends_on = [kubectl_manifest.letsencryptcert]
}