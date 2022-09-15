module "codecov" {
  source                   = "..\\..\\terraform-k8s-codecov"
  postgres_username        = local.postgres_username
  postgres_url             = local.postgres_url
  postgres_password        = local.postgres_password
  postgres_host            = local.postgres_host
  redis_url                = local.redis_url
  minio_domain             = local.minio_domain
  codecov_yml_file         = file(var.codecov_yml)
  enable_certmanager       = var.enable_certmanager
  ingress_enabled          = var.ingress_enabled
  letsencrypt_email        = var.letsencrypt_email
  minio_name               = kubernetes_service.minio.metadata.0.name
  minio                    = true
  minio_primary_access_key = data.terraform_remote_state.cluster.outputs.minio_primary_access_key
}