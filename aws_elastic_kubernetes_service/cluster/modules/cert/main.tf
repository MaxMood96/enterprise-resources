resource "aws_acm_certificate" "cert" {
  count                     = var.enabled ? 1 : 0
  domain_name               = var.domain_name
  validation_method         = var.validation_method
  subject_alternative_names = var.subject_alternative_names

  tags = var.tags
}

locals {
  dvo = var.validate && var.enabled ? {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}
}

data "aws_route53_zone" "zone" {
  count        = var.enabled && var.validate ? 1 : 0
  zone_id      = var.hosted_zone_id
  private_zone = false
  provider     = aws.route53
}

resource "aws_route53_record" "record" {
  for_each = local.dvo

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = join("", data.aws_route53_zone.zone.*.zone_id)
  provider        = aws.route53
}

resource "aws_acm_certificate_validation" "validation" {
  count                   = var.enabled && var.validate ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert[count.index].arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}