resource "kubernetes_manifest" "letsencryptclusterissuer" {
  count = var.enable_certmanager ? 1 : 0
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt"
    }
    spec = {
      acme = {
        server         = "https://acme-v02.api.letsencrypt.org/directory"
        preferredChain = "ISRG Root X1"
        email          = "jason.ford01@gmail.com"
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
  }
}
resource "kubernetes_manifest" "letsencryptissuer" {
  count = var.enable_certmanager ? 1 : 0
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"
    metadata = {
      name      = "letsencrypt-prod"
      namespace = "default"
    }
    spec = {
      acme = {
        # The ACME server URL
        server = "https://acme-v02.api.letsencrypt.org/directory"
        # Email address used for ACME registration
        email = "jason.ford01@gmail.com"
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
  }
}
resource "kubernetes_manifest" "letsencryptcert" {
  count = var.enable_certmanager ? 1 : 0
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind : "Certificate"
    metadata = {
      name      = "acme-crt"
      namespace = "default"
    }
    spec = {
      secretName = "codecov-cert"
      dnsNames   = [data.terraform_remote_state.cluster.outputs.codecov_url]

      issuerRef = {
        name = "letsencrypt-prod"
        # We can reference ClusterIssuers by changing the kind here.
        # The default value is Issuer (i.e. a locally namespaced Issuer)
        kind  = "Issuer"
        group = "cert-manager.io"
      }
    }
  }
}
resource "kubernetes_secret_v1" "tls-secret" {
  count = var.enable_external_tls ? 1 : 0
  metadata {
    name      = "tls-cert"
    namespace = "default"
  }
  type = "tls"
  data = {
    "tls.crt" = var.tls_cert
    "tls.key" = var.tls_key
  }

}

