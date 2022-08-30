data "azurerm_dns_zone" "zone" {
  name = var.zone_name
}

resource "azurerm_dns_a_record" "record" {
  name                = var.root_domain ? "@" : var.dns_name
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = data.azurerm_dns_zone.zone.resource_group_name
  ttl                 = 300
  records             = [var.record]
}