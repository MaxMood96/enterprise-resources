module "codecov" {
  source = "..\\..\\terraform-k8s-codecov"
  namespace = kubernetes_namespace.codecov[0].metadata.0.name
  postgres_username = local.postgres_username
  postgres_url = local.postgres_url
  postgres_password = local.postgres_password
  postgres_host = local.postgres_host
  redis_url = local.redis_url
  minio_domain = local.minio_domain
  common_env = local.common_env
  common_secret_env = local.common_secret_env
  codecov_yml_file = file(var.codecov_yml)
}