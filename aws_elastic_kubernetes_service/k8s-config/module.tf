module "codecov" {
  source                   = "..\\..\\terraform-k8s-codecov"
  postgres_url             = local.postgres_url
  redis_url                = local.redis_url
  codecov_yml_file         = var.codecov_yml
  ingress_enabled          = false #
  minio_name              = local.minio_envs.SERVICES__MINIO__BUCKET
  minio_domain            = local.minio_envs.SERVICES__MINIO__HOST
  enable_aws_minio_env_run_as = true
}