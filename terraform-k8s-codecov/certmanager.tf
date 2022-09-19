resource "helm_release" "cm" {
  count            = var.ingress_enabled && var.enable_certmanager ? 1 : 0
  name             = "certmanager"
  create_namespace = false
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  set {
    name  = "installCRDs"
    value = "true"
  }
}