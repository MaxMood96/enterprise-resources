variable "extra_secret_volumes" {}
variable "extra_env" {}
module "codecov" {
  source = "../../terraform-k8s-codecov"
  minio_bucket = "placeholder"
  minio_domain = "placeholder"
  postgres_url = "placeholder"
  redis_url = "placeholder"
  extra_secret_volumes = var.extra_secret_volumes
  extra_env = var.extra_env
}