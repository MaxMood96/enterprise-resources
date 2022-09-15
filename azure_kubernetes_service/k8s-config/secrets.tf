resource "kubernetes_secret" "codecov-yml" {
  metadata {
    name        = "codecov-yml"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  data = {
    "codecov.yml" = file(var.codecov_yml)
  }
}