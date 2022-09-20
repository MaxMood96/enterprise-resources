module "metrics" {
  count              = var.metrics_enabled ? 1 : 0
  source             = "../../modules/metrics"
  url                = var.ingress_host
  namespace          = var.namespace
  storage_class_name = kubernetes_storage_class.ebs.metadata.0.name
}