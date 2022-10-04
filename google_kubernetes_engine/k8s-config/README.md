<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.38.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.13.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_codecov"></a> [codecov](#module\_codecov) | ../../terraform-k8s-codecov | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ../../modules/dns/gcp | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_managed_ssl_certificate.cert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) | resource |
| [kubernetes_ingress_v1.example_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_resources"></a> [api\_resources](#input\_api\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "1000m",<br>  "cpu_request": "250m",<br>  "memory_limit": "2048M",<br>  "memory_request": "256M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_cert_enabled"></a> [cert\_enabled](#input\_cert\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Google Kubernetes Engine (GKE) cluster name | `string` | `"default-codecov-cluster"` | no |
| <a name="input_codecov_version"></a> [codecov\_version](#input\_codecov\_version) | Version of codecov enterprise to deploy | `string` | `"latest-stable"` | no |
| <a name="input_codecov_yml"></a> [codecov\_yml](#input\_codecov\_yml) | Path to your codecov.yml | `string` | `"../../codecov.yml"` | no |
| <a name="input_dns_enabled"></a> [dns\_enabled](#input\_dns\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_dns_region"></a> [dns\_region](#input\_dns\_region) | Google cloud region | `string` | `"us-east4"` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | Dns zone | `string` | `""` | no |
| <a name="input_enable_external_tls"></a> [enable\_external\_tls](#input\_enable\_external\_tls) | use if you have your own certificate and input tls\_key and tls\_cert | `string` | `"0"` | no |
| <a name="input_enable_https"></a> [enable\_https](#input\_enable\_https) | Enables https ingress.  Requires TLS cert and key | `string` | `"0"` | no |
| <a name="input_extra_env"></a> [extra\_env](#input\_extra\_env) | Map of extra environment variables to add | `map` | `{}` | no |
| <a name="input_extra_secret_env"></a> [extra\_secret\_env](#input\_extra\_secret\_env) | Map of extra environment variables to add as a secret and them source from the secret | `map` | `{}` | no |
| <a name="input_extra_secret_volumes"></a> [extra\_secret\_volumes](#input\_extra\_secret\_volumes) | Map of extra volumes to mount to the Codecov deployments. This is primarily used to mount github app integration secret key. | `map` | `{}` | no |
| <a name="input_gcloud_project"></a> [gcloud\_project](#input\_gcloud\_project) | Google cloud project | `string` | `""` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | Hostname used for http(s) ingress | `any` | n/a | yes |
| <a name="input_minio_bucket_force_destroy"></a> [minio\_bucket\_force\_destroy](#input\_minio\_bucket\_force\_destroy) | Force is required to destroy the cloud sql bucket when it contains data | `string` | `"false"` | no |
| <a name="input_minio_bucket_location"></a> [minio\_bucket\_location](#input\_minio\_bucket\_location) | Location of GCS bucket | `string` | `"US"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to deploy Codecov into | `string` | `"codecov"` | no |
| <a name="input_node_pool_machine_type"></a> [node\_pool\_machine\_type](#input\_node\_pool\_machine\_type) | Machine type to use for the default node pool | `string` | `"n1-standard-1"` | no |
| <a name="input_node_pool_worker_machine_type"></a> [node\_pool\_worker\_machine\_type](#input\_node\_pool\_worker\_machine\_type) | Machine type to use for the worker node pool | `string` | `"n1-standard-4"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Instance type used for postgres instance | `string` | `"db-f1-micro"` | no |
| <a name="input_redis_memory_size"></a> [redis\_memory\_size](#input\_redis\_memory\_size) | Memory size in GB for redis instance | `string` | `"5"` | no |
| <a name="input_region"></a> [region](#input\_region) | Google cloud region | `string` | `"us-east4"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | n/a | `map(any)` | <pre>{<br>  "application": "codecov",<br>  "environment": "test"<br>}</pre> | no |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | n/a | `bool` | `true` | no |
| <a name="input_scm_ca_cert"></a> [scm\_ca\_cert](#input\_scm\_ca\_cert) | SCM CA certificate path | `string` | `""` | no |
| <a name="input_statsd_enabled"></a> [statsd\_enabled](#input\_statsd\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_tls_cert"></a> [tls\_cert](#input\_tls\_cert) | Path to certificate to use for TLS | `string` | `""` | no |
| <a name="input_tls_key"></a> [tls\_key](#input\_tls\_key) | Path to private key to use for TLS | `string` | `""` | no |
| <a name="input_web_node_pool_count"></a> [web\_node\_pool\_count](#input\_web\_node\_pool\_count) | Number of nodes to create in the default node pool | `string` | `"1"` | no |
| <a name="input_web_resources"></a> [web\_resources](#input\_web\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "1000m",<br>  "cpu_request": "150m",<br>  "memory_limit": "2048M",<br>  "memory_request": "128M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_worker_node_pool_count"></a> [worker\_node\_pool\_count](#input\_worker\_node\_pool\_count) | Number of nodes to create in the default node pool | `string` | `"1"` | no |
| <a name="input_worker_resources"></a> [worker\_resources](#input\_worker\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "3000m",<br>  "cpu_request": "500m",<br>  "memory_limit": "1024M",<br>  "memory_request": "1024M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Default Google cloud zone for zone-specific services | `string` | `"us-east4a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns"></a> [dns](#output\_dns) | n/a |
| <a name="output_lb_ip"></a> [lb\_ip](#output\_lb\_ip) | n/a |
<!-- END_TF_DOCS -->