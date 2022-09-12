resource "kubectl_manifest" "letsencryptclusterissuer" {
  count = var.enable_certmanager && var.ingress_enabled ? 1 : 0
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt"
    }
    spec = {
      acme = {
        server         = var.letsencrypt_server
        preferredChain = "ISRG Root X1"
        email          = var.letsencrypt_email
        privateKeySecretRef = {
          name = "letsencrypt"
        }
        solvers = [{
          http01 = {
            ingress = {
              class = "nginx"
              podTemplate = {
                spec = {
                  nodeSelector = tomap({ "kubernetes.io/os" = "linux" })
                }
              }
            }
          }
        }]
      }
    }
  })
  depends_on = [helm_release.cm]
}
resource "kubectl_manifest" "letsencryptissuer" {
  count = var.enable_certmanager && var.ingress_enabled ? 1 : 0
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"
    metadata = {
      name      = "letsencrypt-prod"
      namespace = var.namespace
    }
    spec = {
      acme = {
        # The ACME server URL
        server = var.letsencrypt_server
        # Email address used for ACME registration
        email = var.letsencrypt_email
        # Name of a secret used to store the ACME account private key
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        # Enable the HTTP-01 challenge provider
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  })
  depends_on = [helm_release.cm]
}
resource "kubectl_manifest" "letsencryptcert" {
  count = var.enable_certmanager && var.ingress_enabled ? 1 : 0
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind : "Certificate"
    metadata = {
      name      = "codecov-crt"
      namespace = var.namespace
    }
    spec = {
      secretName = "codecov-cert"
      dnsNames   = [local.codecov_url]

      issuerRef = {
        name = "letsencrypt-prod"
        # We can reference ClusterIssuers by changing the kind here.
        # The default value is Issuer (i.e. a locally namespaced Issuer)
        kind  = "Issuer"
        group = "cert-manager.io"
      }
    }
  })
  depends_on = [helm_release.cm]
}
resource "kubectl_manifest" "letsencryptcertminio" {
  count = var.enable_certmanager && var.ingress_enabled ? 1 : 0
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind : "Certificate"
    metadata = {
      name      = "minio-crt"
      namespace = var.namespace
    }
    spec = {
      secretName = "minio-cert"
      dnsNames   = [local.minio_domain]

      issuerRef = {
        name = "letsencrypt-prod"
        # We can reference ClusterIssuers by changing the kind here.
        # The default value is Issuer (i.e. a locally namespaced Issuer)
        kind  = "Issuer"
        group = "cert-manager.io"
      }
    }
  })
  depends_on = [helm_release.cm]
}
resource "kubernetes_secret_v1" "tls-secret" {
  count = var.enable_external_tls ? 1 : 0
  metadata {
    name      = "tls-cert"
    namespace = var.namespace
  }
  type = "tls"
  data = {
    "tls.crt" = var.tls_cert
    "tls.key" = var.tls_key
  }
}

