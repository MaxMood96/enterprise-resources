resource "aws_route53_record" "record" {
  count           = var.dns_enabled && var.ingress_enabled ? 1 : 0
  allow_overwrite = true
  name            = var.ingress_host
  records         = [local.ingress_hostname]
  ttl             = 60
  type            = "CNAME"
  zone_id         = var.hosted_zone_id
}