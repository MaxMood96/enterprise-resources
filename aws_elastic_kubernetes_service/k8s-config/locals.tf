
locals {
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
    "alb.ingress.kubernetes.io/target-type": "ip"
  }, local.https_annotations)
}