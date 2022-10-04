resource "google_compute_managed_ssl_certificate" "cert" {
  count = var.cert_enabled ? 1 : 0
  name = "codecov-cert-enterprise"

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = [var.ingress_host]
  }
}
