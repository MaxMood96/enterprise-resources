locals {
  postgres_username   = "${data.terraform_remote_state.cluster.outputs.postgres_username}@${data.terraform_remote_state.cluster.outputs.postgres_server_name}"
  postgres_url        = "postgres://${local.postgres_username}:${local.postgres_password}@${local.postgres_host}/codecov"
  postgres_password   = data.terraform_remote_state.cluster.outputs.postgres_pw
  postgres_host       = "${data.terraform_remote_state.cluster.outputs.postgres_fqdn}:5432"
  redis_url           = "redis://${data.terraform_remote_state.cluster.outputs.redis_hostname}:${data.terraform_remote_state.cluster.outputs.redis_port}"
  enable_certmanager  = var.enable_certmanager ? { run = true } : {}
  enable_external_tls = var.enable_external_tls ? { run = true } : {}
}


