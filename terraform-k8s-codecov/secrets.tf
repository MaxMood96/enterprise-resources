resource "kubernetes_secret" "codecov-yml" {
  metadata {
    name        = "codecov-yml"
    annotations = var.resource_tags
    namespace = local.namespace
  }
  data = {
    "codecov.yml" = local.codecov_yaml
  }
}

resource "kubernetes_secret" "scm-ca-cert" {
  metadata {
    name        = "scm-ca-cert"
    annotations = var.resource_tags
    namespace = local.namespace

  }
  data = {
    "scm_ca_cert.pem" = var.scm_ca_cert != "" ? file(var.scm_ca_cert) : ""
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
  count = var.minio_secret ? 1 : 0
  metadata {
    name      = "minio-secrets"
    namespace = local.namespace
  }
  data = {
    MINIO_ACCESS_KEY = var.minio_name
    MINIO_SECRET_KEY = var.minio_primary_access_key
  }
}
