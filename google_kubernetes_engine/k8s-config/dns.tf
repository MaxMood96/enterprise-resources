module "dns" {
  count       = var.dns_enabled && var.ingress_enabled ? 1 : 0
  source      = "../../modules/dns/gcp"
  dns_name    = local.tld
  record      = local.lb_ip
  zone_name   = var.dns_zone
  root_domain = var.root_domain
  providers = {
    google.dns = google.dns
  }
}