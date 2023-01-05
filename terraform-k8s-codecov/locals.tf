locals {
  postgres_url        = var.postgres_url
  redis_url           = var.redis_url
  timescale_url       = var.timescale_url
  namespace           = var.namespace == "default" ? "default" : kubernetes_namespace.codecov[0].metadata[0].name
  codecov_yaml        = file("${path.root}/${var.codecov_yml_file}")
  codecov_yaml_object = yamldecode(local.codecov_yaml)
  codecov_url         = trimprefix(local.codecov_yaml_object["setup"]["codecov_url"], ("https://"))
  enable_certmanager  = var.enable_certmanager ? { run = true } : {}
  enable_external_tls = var.enable_external_tls ? { run = true } : {}
  minio               = var.minio_enabled ? { run = true } : {}
  timescale           = var.timescale_enabled ? {
    SERVICES__TIMESERIES_DATABASE_URL = local.timescale_url
    SETUP__TIMESERIES__ENABLED = true
  } : {}

  minio_cert          = var.minio_enabled && var.enable_certmanager ? { run = true } : {}
  minio_domain        = var.minio_domain
  common_env = merge({
    SERVICES__DATABASE_URL      = local.postgres_url
    SERVICES__REDIS_URL         = local.redis_url
    SERVICES__MINIO__HOST       = local.minio_domain
    SERVICES__MINIO__VERIFY_SSL = true
    SERVICES__MINIO__PORT       = 443
    SERVICES__MINIO__BUCKET     = var.minio_bucket
  },local.timescale, var.extra_env)
  secret_env = { for k, v in var.extra_secret_env :
    k => {
      secret = kubernetes_secret.secret_env[0].metadata.0.name
      key    = v
    }
  }
}