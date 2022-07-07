module "cert" {
  enabled                   = var.cert_enabled && var.dns_enabled
  source                    = "./modules/cert"
  hosted_zone_id            = var.hosted_zone_id
  domain_name               = var.ingress_host
  subject_alternative_names = var.cert_san
  tags                      = var.resource_tags
  validate                  = true
  providers = {
    aws         = aws
    aws.route53 = aws
  }
}