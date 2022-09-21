resource "kubernetes_secret" "codecov-yml" {
  metadata {
    name        = "codecov-yml"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  data = {
    "codecov.yml" = local.codecov_yaml
  }
}

resource "kubernetes_secret" "extra" {
  for_each = var.extra_secret_volumes
  metadata {
    name        = each.key
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  data = {
    "${each.value.file_name}" = file(each.value.local_path)
  }
}

resource "kubernetes_secret" "secret_env" {
  count = var.extra_secret_env == {} ? 0 : 1
  metadata {
    name        = "secret-env"
    annotations = var.resource_tags
    namespace   = local.namespace
  }
  data = { for k, v in var.extra_secret_env : k => v }
}
