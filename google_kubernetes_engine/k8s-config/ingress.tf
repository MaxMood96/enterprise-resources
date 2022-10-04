resource "kubernetes_ingress_v1" "example_ingress" {
  count = var.ingress_enabled && var.cert_enabled ? 1 : 0
  metadata {
    name      = "codecov-ingress"
    namespace = module.codecov.namespace_name
    annotations = {
      "ingress.gcp.kubernetes.io/pre-shared-cert" : var.cert_enabled ? google_compute_managed_ssl_certificate.cert[count.index].name : ""
      "kubernetes.io/ingress.allow-http" : "true"
      "kubernetes.io/ingress.class" : "gce"
    }
  }
  wait_for_load_balancer = true

  spec {
    rule {
      host = var.ingress_host
      http {
        path {
          path = "/"
          backend {
            service {
              name = "web"
              port {
                number = 5000
              }
            }
          }
        }
        path {
          path = "/*"
          backend {
            service {
              name = "web"
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
  depends_on = [module.codecov]
}

