
resource "kubernetes_service_account" "codecov" {
  metadata {
    name        = "codecov"
    namespace   = local.namespace
    annotations = var.service_account_annotations
  }
}
/*
resource "kubernetes_manifest_v1" "tokenRequest" {
  manifest = {
    "apiVersion" = "authentication.k8s.io/v1"
    "kind" = "TokenRequest"
    "metadata" = {
      "name" = "tokenRequest"
    }
    spec = {
      "audiences" = [kubernetes_service_account.codecov.metadata[0].name]
    }
  }
}*/