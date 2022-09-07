locals {
    postgres_username   = var.postgres_username
    postgres_url        = var.postgres_url
    postgres_password   = var.postgres_password
    postgres_host       = var.postgres_host
    redis_url           = var.redis_url
    namespace           = var.namespace
    minio_domain =  var.minio_domain
    common_env = var.common_env
    common_secret_env = var.common_secret_env
}