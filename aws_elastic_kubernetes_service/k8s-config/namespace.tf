resource "kubernetes_namespace" "codecov" {
  count = var.codecov_namespace == "default" ? 0 : 1
  metadata {
    name   = var.codecov_namespace
    labels = var.resource_tags
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}
