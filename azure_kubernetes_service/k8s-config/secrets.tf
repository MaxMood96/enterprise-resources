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

resource "kubernetes_secret" "minio-secrets" {
  metadata {
    name      = "minio-secrets"
    namespace = local.namespace
  }
  data = {
    MINIO_ACCESS_KEY = data.terraform_remote_state.cluster.outputs.minio_name
    MINIO_SECRET_KEY = data.terraform_remote_state.cluster.outputs.minio_primary_access_key
  }
}