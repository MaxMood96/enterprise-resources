## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.6.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.13.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure-dns"></a> [azure-dns](#module\_azure-dns) | ../../modules/dns/azure | n/a |
| <a name="module_azure-dns-minio"></a> [azure-dns-minio](#module\_azure-dns-minio) | ../../modules/dns/azure | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.cm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.letsencryptcert](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.letsencryptcertminio](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.letsencryptclusterissuer](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.letsencryptissuer](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_deployment.api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.minio_storage](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.worker](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_ingress_v1.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.codecov](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.codecov-yml](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.extra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.minio-secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret_v1.tls-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service.api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.minio](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_resources"></a> [api\_resources](#input\_api\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "1000m",<br>  "cpu_request": "250m",<br>  "memory_limit": "2048M",<br>  "memory_request": "256M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_codecov_version"></a> [codecov\_version](#input\_codecov\_version) | Version of codecov enterprise to deploy | `string` | `"latest-stable"` | no |
| <a name="input_codecov_yml"></a> [codecov\_yml](#input\_codecov\_yml) | Path to your codecov.yml | `string` | `"codecov.yml"` | no |
| <a name="input_dns_enabled"></a> [dns\_enabled](#input\_dns\_enabled) | Attempt to create a DNS record for the ingress. Requires the ingress to be enabled and dns\_zone to be set to a valid dns zone | `bool` | `false` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | n/a | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain that your app is hosted on. E.g. codecov.io. This is used for minio dns. minio.codecov.io for example | `string` | `""` | no |
| <a name="input_enable_certmanager"></a> [enable\_certmanager](#input\_enable\_certmanager) | enables lets encrypt and creates certificate request based off codecov url in codecov.yml file | `string` | `"1"` | no |
| <a name="input_enable_external_tls"></a> [enable\_external\_tls](#input\_enable\_external\_tls) | use if you have your own certificate and input tls\_key and tls\_cert | `string` | `"0"` | no |
| <a name="input_extra_secret_volumes"></a> [extra\_secret\_volumes](#input\_extra\_secret\_volumes) | Map of extra volumes to mount to the Codecov deployments. This is primarily used to mount github app integration secret key. | `map` | `{}` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Deploy nginx ingress? | `bool` | `true` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email to use with letsencrypt. This is required if enable\_certmanager is enabled | `string` | `""` | no |
| <a name="input_letsencrypt_server"></a> [letsencrypt\_server](#input\_letsencrypt\_server) | n/a | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_minio_resources"></a> [minio\_resources](#input\_minio\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "256m",<br>  "cpu_request": "32m",<br>  "memory_limit": "512M",<br>  "memory_request": "64M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"codecov"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | n/a | `map(any)` | <pre>{<br>  "application": "codecov",<br>  "environment": "test"<br>}</pre> | no |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | Set to true if your Codecov url is the root of your dns zone | `bool` | `false` | no |
| <a name="input_statsd_enabled"></a> [statsd\_enabled](#input\_statsd\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_tls_cert"></a> [tls\_cert](#input\_tls\_cert) | Path to certificate to use for TLS | `string` | `""` | no |
| <a name="input_tls_key"></a> [tls\_key](#input\_tls\_key) | Path to private key to use for TLS | `string` | `""` | no |
| <a name="input_web_resources"></a> [web\_resources](#input\_web\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "1000m",<br>  "cpu_request": "150m",<br>  "memory_limit": "2048M",<br>  "memory_request": "128M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_worker_resources"></a> [worker\_resources](#input\_worker\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "3000m",<br>  "cpu_request": "500m",<br>  "memory_limit": "1024M",<br>  "memory_request": "1024M",<br>  "replicas": 2<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codecov_name"></a> [codecov\_name](#output\_codecov\_name) | n/a |
| <a name="output_codecov_url"></a> [codecov\_url](#output\_codecov\_url) | n/a |
| <a name="output_ingress-lb-ip"></a> [ingress-lb-ip](#output\_ingress-lb-ip) | n/a |
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | n/a |
| <a name="output_minio_host"></a> [minio\_host](#output\_minio\_host) | n/a |
