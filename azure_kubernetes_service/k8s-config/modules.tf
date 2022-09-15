module "codecov" {
  source                   = "..\\..\\terraform-k8s-codecov"
  postgres_username        = local.postgres_username
  postgres_url             = local.postgres_url
  postgres_password        = local.postgres_password
  postgres_host            = local.postgres_host
  redis_url                = local.redis_url
  minio_domain             = local.minio_domain
  codecov_yml_file         = var.codecov_yml
  enable_certmanager       = var.enable_certmanager
  ingress_enabled          = var.ingress_enabled
  letsencrypt_email        = var.letsencrypt_email
  minio                    = var.minio
  minio_secret            = var.minio_secrets
  minio_name              = data.terraform_remote_state.cluster.outputs.minio_name
  minio_primary_access_key = data.terraform_remote_state.cluster.outputs.minio_primary_access_key
}