locals {
  postgres_username   = data.terraform_remote_state.cluster.outputs.postgres_username
  postgres_url        = "postgres://${local.postgres_username}:${local.postgres_password}@${local.postgres_host}/codecov"
  postgres_password   = data.terraform_remote_state.cluster.outputs.postgres_pw
  postgres_host       = "${data.terraform_remote_state.cluster.outputs.postgres_ip}:5432"
  redis_url           = "redis://${data.terraform_remote_state.cluster.outputs.redis_hostname}:${data.terraform_remote_state.cluster.outputs.redis_port}"
  enable_external_tls = var.enable_external_tls ? { run = true } : {}
  namespace           = var.namespace == "default" ? var.namespace : module.codecov.namespace_name
  tld                 = split(".", module.codecov.ingress_host)[0]
  minio_domain        = data.terraform_remote_state.cluster.outputs.minio_domain
  dns_zone            = var.dns_zone
  lb_ip               = kubernetes_ingress_v1.example_ingress[0].status[0].load_balancer[0].ingress[0].ip
  extra_env = merge(var.extra_env, {
    SERVICES__MINIO__REGION = var.region
  })
  extra_secret_env = merge(var.extra_secret_env, {
    SERVICES__MINIO__ACCESS_KEY_ID     = local.connection_strings.minio_access_key
    SERVICES__MINIO__SECRET_ACCESS_KEY = local.connection_strings.minio_secret_key
  })
  connection_strings = {
    minio_access_key = data.terraform_remote_state.cluster.outputs.minio_access_key
    minio_secret_key = data.terraform_remote_state.cluster.outputs.minio_secret_key
  }
}