
resource "helm_release" "nginx" {
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  set {
    name  = "controller.replicaCount"
    value = "2"
  }
  set {
    name  = "controller\\.nodeSelector\\.\"kubernetes\\.io/os\""
    value = "linux"
  }
  set {
    name  = "controller\\.admissionWebhooks\\.patch.nodeSelector\\.\"kubernetes\\.io/os\""
    value = "linux"
  }
  set {
    name  = "controller\\.service\\.annotations\\.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path\""
    value = "/healthz"
  }
  set {
    name  = "defaultBackend\\.nodeSelector\\.\"kubernetes\\.io/os\""
    value = "linux"
  }
}
