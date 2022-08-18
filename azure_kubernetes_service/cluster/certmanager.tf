resource "helm_release" "cm" {
  name             = "certmanager"
  create_namespace = false
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  set {
    name  = "installCRDs"
    value = "true"
  }
}