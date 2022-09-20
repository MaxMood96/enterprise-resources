locals {
 // postgres_username   = var.postgres_username
  postgres_url        = var.postgres_url
  //postgres_password   = var.postgres_password
//  postgres_host       = var.postgres_host
  redis_url           = var.redis_url
  namespace           = var.namespace == "default" ? "default" : kubernetes_namespace.codecov[0].metadata[0].name
  codecov_yaml        = yamldecode(file("${path.root}/${var.codecov_yml_file}"))
  codecov_url         = trimprefix(local.codecov_yaml["setup"]["codecov_url"], ("https://"))
  enable_certmanager  = var.enable_certmanager ? { run = true } : {}
  enable_external_tls = var.enable_external_tls ? { run = true } : {}
  enable_aws_minio_env_run_as = var.enable_aws_minio_env_run_as ? { run = true } : {}
  minio               = var.minio ? { run = true } : {}
  minio_cert          = var.minio && var.enable_certmanager ? { run = true } : {}
  minio_domain        = var.minio_domain
  common_env = {
    SERVICES__DATABASE_URL      = local.postgres_url
    SERVICES__REDIS_URL         = local.redis_url
    SERVICES__MINIO__HOST       = local.minio_domain
    SERVICES__MINIO__VERIFY_SSL = "true"
    SERVICES__MINIO__PORT       = "443"
    SERVICES__MINIO__BUCKET     = var.minio_name
  }
  common_secret_env = var.minio_secret ? {
    SERVICES__MINIO__ACCESS_KEY_ID = {
      secret = kubernetes_secret.minio-secrets[0].metadata.0.name
      key    = "MINIO_ACCESS_KEY"
    }
    SERVICES__MINIO__SECRET_ACCESS_KEY = {
      secret = kubernetes_secret.minio-secrets[0].metadata.0.name
      key    = "MINIO_SECRET_KEY"
    }
  } : {}
}
data "kubernetes_secret" "aws_minio_creds" {
  count = var.enable_aws_minio_env_run_as ? 1 : 0
  metadata {
    name = "minio-creds"
  }
}