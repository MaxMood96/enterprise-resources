resource "kubernetes_ingress_v1" "ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "nginx-ingress"
  }
  spec {
    ingress_class_name = "nginx"
    dynamic "tls" {
      for_each = local.enable_certmanager
      content {
        secret_name = kubernetes_manifest.letsencryptcert.*.manifest.spec[0].secretName
        hosts       = [data.terraform_remote_state.cluster.outputs.codecov_url]
      }
    }
    dynamic "tls" {
      for_each = local.enable_external_tls
      content {
        secret_name = kubernetes_secret_v1.tls-secret[0].metadata[0].name
        hosts       = [data.terraform_remote_state.cluster.outputs.codecov_url]
      }
    }
    rule {
      host = data.terraform_remote_state.cluster.outputs.codecov_url
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
  }
}