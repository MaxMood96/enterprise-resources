data "aws_acm_certificate" "issued" {
  count    = var.cert_enabled ? 1 : 0
  domain   = var.ingress_host
  statuses = ["ISSUED"]
}

data "aws_iam_role" "ingress" {
  count = var.ingress_enabled ? 1 : 0
  name  = data.terraform_remote_state.cluster.outputs.ingress_role
}


resource "kubernetes_service_account" "ingress" {
  count                           = var.ingress_enabled ? 1 : 0
  automount_service_account_token = true
  metadata {
    name      = "alb-ingress-controller"
    namespace = var.ingress_namespace
    annotations = {
      # This annotation is only used when running on EKS which can
      # use IAM roles for service accounts.
      "eks.amazonaws.com/role-arn" = data.terraform_remote_state.cluster.outputs.alb_role_arn
    }
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
resource "helm_release" "ingress" {
  depends_on       = [kubernetes_manifest.ingress-crd1, kubernetes_manifest.ingress-crd2]
  count            = var.ingress_enabled ? 1 : 0
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = var.ingress_namespace
  create_namespace = true
  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = "alb-ingress-controller"
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "image.repository"
    value = "${local.registries[var.region]}/amazon/aws-load-balancer-controller"
  }
}

resource "kubernetes_ingress_v1" "ingress" {
  count                  = var.ingress_enabled ? 1 : 0
  wait_for_load_balancer = true
  metadata {
    name        = "codecov-ingress"
    namespace   = var.namespace
    annotations = local.ingress_annotations
  }
  spec {
    rule {
      host = var.ingress_host
      http {
        dynamic "path" {
          content {
            path = path.value.path
            backend {
              service {
                name = path.value.service
                port {
                  number = path.value.port
                }
              }
            }
          }
          for_each = local.metrics_paths
        }
        path {
          path = "/"
          backend {
            service {
              name = "gateway"
              port {
                number = 8080
              }
            }
          }
        }
        path {
          path = "/*"
          backend {
            service {
              name = "gateway"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
  depends_on = [module.codecov]
}
#https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/deploy/installation/#summary
#https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/crds/crds.yaml
resource "kubernetes_manifest" "ingress-crd1" {
  count    = var.ingress_enabled ? 1 : 0
  manifest = yamldecode(file("crds/1.yaml"))
}

resource "kubernetes_manifest" "ingress-crd2" {
  count    = var.ingress_enabled ? 1 : 0
  manifest = yamldecode(file("crds/2.yaml"))
}

output "ingress_hostname" {
  value = local.ingress_hostname
}