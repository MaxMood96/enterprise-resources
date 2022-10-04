
data "google_dns_managed_zone" "zone" {
  name = var.zone_name
}

resource "google_dns_record_set" "record" {
  name         = var.root_domain ? data.google_dns_managed_zone.zone.dns_name : "${var.dns_name}.${data.google_dns_managed_zone.zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.zone.name
  rrdatas      = [var.record]
}