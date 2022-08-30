module "azure-dns" {
  count       = var.dns_enabled && var.ingress_enabled ? 1 : 0
  source      = "../../modules/dns/azure"
  dns_name    = local.tld
  record      = local.lb_ip
  zone_name   = var.dns_zone
  root_domain = var.root_domain
  providers = {
    azurerm.dns = azurerm.dns
  }
}

module "azure-dns-minio" {
  count       = var.dns_enabled && var.ingress_enabled ? 1 : 0
  source      = "../../modules/dns/azure"
  dns_name    = "minio"
  record      = local.lb_ip
  zone_name   = var.dns_zone
  root_domain = false
  providers = {
    azurerm.dns = azurerm.dns
  }
}
# Example aws dns (route53). The dns modules are designed to have the same interface. You just need to provide a configured terraform provider
#module "aws-dns" {
#  count = var.dns_enabled && var.ingress_enabled ? 1 : 0
#  source = "../../modules/dns/aws"
#  dns_name = local.tld
#  record = local.lb_ip
#  zone_name = var.dns_zone
#  root_domain = var.root_domain
#  providers = {
#    google.dns = google.dns
#  }
#}