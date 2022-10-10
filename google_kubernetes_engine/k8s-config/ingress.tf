resource "kubernetes_ingress_v1" "ingress" {
  count = var.ingress_enabled ? 1 : 0
  metadata {
    name        = "codecov-ingress"
    namespace   = module.codecov.namespace_name
    annotations = local.annotations
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

