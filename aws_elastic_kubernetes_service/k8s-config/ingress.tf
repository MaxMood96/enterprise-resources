data "aws_acm_certificate" "issued" {
  count    = var.cert_enabled ? 1 : 0
  domain   = var.ingress_host
  statuses = ["ISSUED"]
}

data "aws_iam_role" "ingress" {
  count = var.ingress_enabled ? 1 : 0
  name  = "codecov-ingress-controller"
}

data "aws_vpc" "vpc" {
  count = var.ingress_enabled ? 1 : 0
  tags = {
    Name = var.vpc_name
  }
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
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.ingress[count.index].arn
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
}

resource "kubernetes_ingress_v1" "ingress" {
  count = var.ingress_enabled ? 1 : 0
  metadata {
    name        = "codecov-ingress"
    namespace   = var.codecov_namespace
    annotations = local.ingress_annotations
  }
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
      }
    }
    rule {
      host = var.ingress_host
      http {
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
  depends_on = [kubernetes_service.web, kubernetes_namespace.codecov]
}
#https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/deploy/installation/#summary
#https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/crds/crds.yaml
#open bug: https://github.com/hashicorp/terraform-provider-kubernetes/issues/1652 this will need to update on every run. This is "fine".
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