locals {
  postgres_username   = "${data.terraform_remote_state.cluster.outputs.postgres_username}@${data.terraform_remote_state.cluster.outputs.postgres_server_name}"
  postgres_url        = "postgres://${local.postgres_username}:${local.postgres_password}@${local.postgres_host}/codecov"
  postgres_password   = data.terraform_remote_state.cluster.outputs.postgres_pw
  postgres_host       = "${data.terraform_remote_state.cluster.outputs.postgres_fqdn}:5432"
  redis_url           = "redis://${data.terraform_remote_state.cluster.outputs.redis_hostname}:${data.terraform_remote_state.cluster.outputs.redis_port}"
  enable_certmanager  = var.enable_certmanager ? { run = true } : {}
  enable_external_tls = var.enable_external_tls ? { run = true } : {}
  codecov_yaml        = yamldecode(file(var.codecov_yml))
  codecov_url         = trimprefix(local.codecov_yaml["setup"]["codecov_url"], ("https://"))
  namespace           = var.namespace == "default" ? var.namespace : kubernetes_namespace.codecov[0].metadata.0.name
  tld                 = split(".", local.codecov_url)[0]
  minio_domain        = "minio.${var.domain}"
  common_env = {
    SERVICES__DATABASE_URL      = local.postgres_url
    SERVICES__REDIS_URL         = local.redis_url
    SERVICES__MINIO__HOST       = local.minio_domain
    SERVICES__MINIO__VERIFY_SSL = "true"
    SERVICES__MINIO__PORT       = "443"
    SERVICES__MINIO__BUCKET     = data.terraform_remote_state.cluster.outputs.minio_name
  }
  common_secret_env = {
    SERVICES__MINIO__ACCESS_KEY_ID = {
      secret = kubernetes_secret.minio-secrets.metadata.0.name
      key    = "MINIO_ACCESS_KEY"
    }
    SERVICES__MINIO__SECRET_ACCESS_KEY = {
      secret = kubernetes_secret.minio-secrets.metadata.0.name
      key    = "MINIO_SECRET_KEY"
    }
  }
  lb_ip = var.ingress_enabled ? module.codecov.lb_ip : ""
}