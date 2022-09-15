locals {
  postgres_username   = var.postgres_username
  postgres_url        = var.postgres_url
  postgres_password   = var.postgres_password
  postgres_host       = var.postgres_host
  redis_url           = var.redis_url
  namespace           = var.namespace
  codecov_yaml        = yamldecode(var.codecov_yml_file)
  codecov_url         = trimprefix(local.codecov_yaml["setup"]["codecov_url"], ("https://"))
  enable_certmanager  = var.enable_certmanager ? { run = true } : {}
  enable_external_tls = var.enable_external_tls ? { run = true } : {}
  minio               = var.minio ? { run = true } : {}
  minio_domain        = var.minio_domain
  common_env = {
    SERVICES__DATABASE_URL      = local.postgres_url
    SERVICES__REDIS_URL         = local.redis_url
    SERVICES__MINIO__HOST       = local.minio_domain
    SERVICES__MINIO__VERIFY_SSL = "true"
    SERVICES__MINIO__PORT       = "443"
    SERVICES__MINIO__BUCKET     = var.minio_name
  }
  common_secret_env = {
    SERVICES__MINIO__ACCESS_KEY_ID = {
      secret = kubernetes_secret.minio-secrets[0].metadata.0.name
      key    = "MINIO_ACCESS_KEY"
    }
    SERVICES__MINIO__SECRET_ACCESS_KEY = {
      secret = kubernetes_secret.minio-secrets[0].metadata.0.name
      key    = "MINIO_SECRET_KEY"
    }
  }
}