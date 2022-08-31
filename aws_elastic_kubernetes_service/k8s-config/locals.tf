locals {
  govcloud_enabled                        = length(regexall("gov", var.region)) > 0
  connection_strings                      = jsondecode(data.aws_secretsmanager_secret_version.connections.secret_string)
  postgres_url                            = local.connection_strings.postgres_url
  redis_url                               = local.connection_strings.redis_url
  aws_alb_ingress_controller_docker_image = "docker.io/amazon/aws-alb-ingress-controller:v${var.ingress_controller_version}"
  aws_alb_ingress_class                   = "alb"
  ingress_hostname                        = var.ingress_enabled ? (length(kubernetes_ingress_v1.ingress[0].status[0].load_balancer[0].ingress) > 0 ? kubernetes_ingress_v1.ingress[0].status[0].load_balancer[0].ingress[0].hostname : "") : ""
  https_annotations = var.cert_enabled ? {
    "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
    "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.issued[0].arn
  } : {}
  ingress_annotations = merge({
    "kubernetes.io/ingress.class"                = "alb"
    "alb.ingress.kubernetes.io/scheme"           = var.ingress_scheme
    "alb.ingress.kubernetes.io/healthcheck-path" = "/login"
    "alb.ingress.kubernetes.io/healthcheck-port" = "traffic-port"
    "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}]"
    "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
    "alb.ingress.kubernetes.io/target-type"      = "ip"
  }, local.https_annotations)
  minio_envs = {
    SERVICES__MINIO__REGION = var.region
    SERVICES__MINIO__PORT   = 443
    #SERVICES__MINIO__IAM_AUTH   = false # we cannot use iam auth here because minio does not currently support aws metadata v2 service
    SERVICES__MINIO__VERIFY_SSL = true
    SERVICES__MINIO__BUCKET     = local.connection_strings.minio_bucket
    SERVICES__MINIO__HOST       = local.govcloud_enabled ? "s3-${var.region}.amazonaws.com" : "s3.amazonaws.com"
    SERVICES__CHOSEN_STORAGE    = "aws"
    SERVICES__AWS__RESOURCE     = "s3"
  }
  # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  registries = {
    af-south-1     = "877085696533.dkr.ecr.af-south-1.amazonaws.com"
    ap-east-1      = "800184023465.dkr.ecr.ap-east-1.amazonaws.com"
    ap-northeast-1 = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com"
    ap-northeast-2 = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com"
    ap-northeast-3 = "602401143452.dkr.ecr.ap-northeast-3.amazonaws.com"
    ap-south-1     = "602401143452.dkr.ecr.ap-south-1.amazonaws.com"
    ap-southeast-1 = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com"
    ap-southeast-2 = "602401143452.dkr.ecr.ap-southeast-2.amazonaws.com"
    ap-southeast-3 = "296578399912.dkr.ecr.ap-southeast-3.amazonaws.com"
    ca-central-1   = "602401143452.dkr.ecr.ca-central-1.amazonaws.com"
    cn-north-1     = "918309763551.dkr.ecr.cn-north-1.amazonaws.com"
    cn-northwest-1 = "961992271922.dkr.ecr.cn-northwest-1.amazonaws.com"
    eu-central-1   = "602401143452.dkr.ecr.eu-central-1.amazonaws.com"
    eu-north-1     = "602401143452.dkr.ecr.eu-north-1.amazonaws.com"
    eu-south-1     = "590381155156.dkr.ecr.eu-south-1.amazonaws.com"
    eu-west-1      = "602401143452.dkr.ecr.eu-west-1.amazonaws.com"
    eu-west-2      = "602401143452.dkr.ecr.eu-west-2.amazonaws.com"
    eu-west-3      = "602401143452.dkr.ecr.eu-west-3.amazonaws.com"
    me-south-1     = "558608220178.dkr.ecr.me-south-1.amazonaws.com"
    sa-east-1      = "602401143452.dkr.ecr.sa-east-1.amazonaws.com"
    us-east-1      = "602401143452.dkr.ecr.us-east-1.amazonaws.com"
    us-east-2      = "602401143452.dkr.ecr.us-east-2.amazonaws.com"
    us-gov-east-1  = "151742754352.dkr.ecr.us-gov-east-1.amazonaws.com"
    us-gov-west-1  = "013241004608.dkr.ecr.us-gov-west-1.amazonaws.com"
    us-west-1      = "602401143452.dkr.ecr.us-west-1.amazonaws.com"
    us-west-2      = "602401143452.dkr.ecr.us-west-2.amazonaws.com"
  }

  metrics_paths = var.metrics_enabled ? {
    grafana = {
      port    = 3000
      service = "grafana"
      path    = "/grafana*"
    }
    prometheus = {
      port    = 9090
      service = "prometheus"
      path    = "/prometheus*"
    }
    statsd_web = {
      port    = 9102
      service = "statsd"
      path    = "/statsd"
    }
    statsd_metrics = {
      port    = 9102
      service = "statsd"
      path    = "/metrics"
    }
  } : {}

}