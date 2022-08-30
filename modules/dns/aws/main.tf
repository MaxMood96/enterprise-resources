data "aws_route53_zone" "zone" {
  name         = var.zone_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "record" {
  allow_overwrite = true
  name            = var.dns_name
  records         = [var.record]
  ttl             = 60
  type            = "CNAME"
  zone_id         = data.aws_route53_zone.zone.id
}