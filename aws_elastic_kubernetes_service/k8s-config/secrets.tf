resource "kubernetes_secret" "minio-creds" {
  metadata {
    name        = "minio-creds"
    annotations = var.resource_tags
    namespace   = var.codecov_namespace
  }
  # Use aws config and set minio for fallback
  data = {
    SERVICES__MINIO__ACCESS_KEY_ID       = local.connection_strings.minio_access_key
    SERVICES__AWS__AWS_ACCESS_KEY_ID     = local.connection_strings.minio_access_key
    SERVICES__MINIO__SECRET_ACCESS_KEY   = local.connection_strings.minio_secret_key
    SERVICES__AWS__AWS_SECRET_ACCESS_KEY = local.connection_strings.minio_secret_key
  }
}

