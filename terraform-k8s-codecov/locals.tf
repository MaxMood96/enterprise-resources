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
    minio = var.minio ? { run = true } : {}
    minio_domain =  var.minio_domain
    common_env = var.common_env
    common_secret_env = var.common_secret_env
}