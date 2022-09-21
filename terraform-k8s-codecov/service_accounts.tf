
resource "kubernetes_service_account" "codecov" {
  metadata {
    name        = "codecov"
    namespace   = local.namespace
    annotations = var.service_account_annotations
  }
}
