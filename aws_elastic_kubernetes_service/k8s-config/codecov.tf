module "codecov" {
  source               = "../../terraform-k8s-codecov"
  extra_secret_env     = local.extra_secret_env
  extra_env            = local.extra_env
  namespace            = var.namespace
  codecov_version      = var.codecov_version
  web_resources        = var.web_resources
  gateway_resources    = var.gateway_resources
  frontend_resources   = var.frontend_resources
  frontend_image       = var.frontend_image
  api_image            = var.api_image
  worker_image         = var.worker_image
  gateway_image        = var.gateway_image
  codecov_repository   = var.codecov_repository
  worker_args          = var.worker_args
  api_resources        = var.api_resources
  worker_resources     = var.worker_resources
  resource_tags        = var.resource_tags
  extra_secret_volumes = var.extra_secret_volumes
  statsd_enabled       = var.statsd_enabled || var.metrics_enabled
  postgres_url         = local.postgres_url
  redis_url            = local.redis_url
  minio_domain         = local.govcloud_enabled ? "s3-${var.region}.amazonaws.com" : "s3.amazonaws.com"
  codecov_yml_file     = var.codecov_yml
  ingress_enabled      = false # We want to use the AWS ingress
  minio_bucket         = local.connection_strings.minio_bucket
  timescale_enabled    = true
  timescale_url        = "${data.terraform_remote_state.timescaledb.outputs.timescale_url}/postgres"
  service_account_annotations = {
    "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.cluster.outputs.codecov_role_name}"
  }
}