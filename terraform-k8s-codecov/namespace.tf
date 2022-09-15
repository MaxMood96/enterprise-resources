resource "kubernetes_namespace" "codecov" {
  count = var.namespace == "default" ? 0 : 1
  metadata {
    name   = var.namespace
    labels = var.resource_tags
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}
