**Note: This module is provided purely as an example and not as an
official Codecov Enterprise deployment strategy. If you want to use
this configuration to test Codecov Enterprise on your own internally
maintained cluster, that is fine. Codecov, however, _will not support_
its use in production environments, nor will we provide support for this
module's installation or continued use in any context.**

# Codecov terraform module for kubernetes

This module provides an example of how to set up Codecov Enterprise in a 
kubernetes cluster.

It is *highly* recommended to deploy Codecov Enterprise into a managed k8s
cluster on one of the major cloud providers: AWS, GCP, or Azure. Those
terraform configurations are supported and provided elsewhere in this
repository. Codecov will fully support these configurations if problems
arise as a result of their use.

## Required services

- A postgresql v10+ (14 recommended) server configured to allow connections from your k8s cluster. 
- A redis server configured to allow connections from your k8s cluster.
- An S3-compatible object store such as [minio](https://min.io/download).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.letsencryptcert](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.letsencryptcertminio](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.letsencryptclusterissuer](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.letsencryptissuer](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_deployment.api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.minio_storage](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.worker](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_ingress_v1.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.codecov](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.codecov-yml](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.extra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.secret_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret_v1.tls-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service.api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.minio](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service_account.codecov](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_resources"></a> [api\_resources](#input\_api\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "1000m",<br>  "cpu_request": "250m",<br>  "memory_limit": "2048M",<br>  "memory_request": "256M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_codecov_version"></a> [codecov\_version](#input\_codecov\_version) | Version of Codecov Enterprise to deploy | `string` | `"latest-stable"` | no |
| <a name="input_codecov_yml_file"></a> [codecov\_yml\_file](#input\_codecov\_yml\_file) | n/a | `any` | `"../codecov.yml"` | no |
| <a name="input_enable_certmanager"></a> [enable\_certmanager](#input\_enable\_certmanager) | enables lets encrypt and creates certificate request based off codecov url in codecov.yml file | `bool` | `false` | no |
| <a name="input_enable_external_tls"></a> [enable\_external\_tls](#input\_enable\_external\_tls) | use if you have your own certificate and input tls\_key and tls\_cert | `bool` | `false` | no |
| <a name="input_extra_env"></a> [extra\_env](#input\_extra\_env) | Map of extra environment variables to add | `map` | `{}` | no |
| <a name="input_extra_secret_env"></a> [extra\_secret\_env](#input\_extra\_secret\_env) | Map of extra environment variables to add as a secret and them source from the secret | `map` | `{}` | no |
| <a name="input_extra_secret_volumes"></a> [extra\_secret\_volumes](#input\_extra\_secret\_volumes) | Map of extra volumes to mount to the Codecov deployments. This is primarily used to mount github app integration secret key. | `map` | `{}` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Deploy nginx ingress? | `bool` | `true` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email to use with letsencrypt. This is required if enable\_certmanager is enabled | `string` | `""` | no |
| <a name="input_letsencrypt_server"></a> [letsencrypt\_server](#input\_letsencrypt\_server) | n/a | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_minio_bucket"></a> [minio\_bucket](#input\_minio\_bucket) | The name of the s3 bucket / GCS bucket / Azure storage account to use to store reports | `string` | n/a | yes |
| <a name="input_minio_domain"></a> [minio\_domain](#input\_minio\_domain) | n/a | `string` | n/a | yes |
| <a name="input_minio_enabled"></a> [minio\_enabled](#input\_minio\_enabled) | Enable to deploy minio into the cluster | `string` | `false` | no |
| <a name="input_minio_resources"></a> [minio\_resources](#input\_minio\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "256m",<br>  "cpu_request": "32m",<br>  "memory_limit": "512M",<br>  "memory_request": "64M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"codecov"` | no |
| <a name="input_postgres_url"></a> [postgres\_url](#input\_postgres\_url) | n/a | `string` | n/a | yes |
| <a name="input_redis_url"></a> [redis\_url](#input\_redis\_url) | n/a | `string` | n/a | yes |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | n/a | `map(any)` | <pre>{<br>  "application": "codecov"<br>}</pre> | no |
| <a name="input_service_account_annotations"></a> [service\_account\_annotations](#input\_service\_account\_annotations) | Annotations to add to the codecov service account | `map(string)` | `{}` | no |
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
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | n/a |
| <a name="output_lb_ip"></a> [lb\_ip](#output\_lb\_ip) | n/a |
| <a name="output_minio_secrets_name"></a> [minio\_secrets\_name](#output\_minio\_secrets\_name) | n/a |
| <a name="output_namespace_name"></a> [namespace\_name](#output\_namespace\_name) | n/a |
| <a name="output_web_name"></a> [web\_name](#output\_web\_name) | n/a |


\* Specifying a codecov_version is recommended and requires the format `v$VERSION` e.g. `v4.6.5`

## Setup

1. Install the module in your terraform project.
2. Configure the module.  Refer to these examples [aws](../aws_elastic_kubernetes_service/k8s-config/codecov.tf) and [azure](../azure_kubernetes_service/k8s-config/codecov.tf).
    
3. Run `terraform init` to import the module and the required terraform
   providers.
4. Carry on with normal [terraform usage](https://learn.hashicorp.com/terraform/getting-started/build.html) (`terraform plan`, `terraform apply`)
