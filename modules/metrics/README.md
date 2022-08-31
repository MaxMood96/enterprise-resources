# Metrics

## Overview
This module deploys a basic grafana/statsd/prometheus deployment. It includes one dashboard for Codecov by default.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_bcrypt"></a> [bcrypt](#requirement\_bcrypt) | 0.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_bcrypt"></a> [bcrypt](#provider\_bcrypt) | 0.1.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [bcrypt_hash.prometheus](https://registry.terraform.io/providers/viktorradnai/bcrypt/0.1.2/docs/resources/hash) | resource |
| [kubernetes_config_map.grafana_dashboards](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.grafana_datasources](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_daemonset.statsd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/daemonset) | resource |
| [kubernetes_namespace.ns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_persistent_volume_claim.grafana](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) | resource |
| [kubernetes_persistent_volume_claim.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) | resource |
| [kubernetes_secret.grafana](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.grafana](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.statsd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.grafana](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |
| [kubernetes_stateful_set.prom](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |
| [random_password.grafana](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.prometheus](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | n/a | `map` | `{}` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | n/a | `bool` | `false` | no |
| <a name="input_extra_prometheus_config"></a> [extra\_prometheus\_config](#input\_extra\_prometheus\_config) | n/a | `map` | `{}` | no |
| <a name="input_extra_prometheus_web_config"></a> [extra\_prometheus\_web\_config](#input\_extra\_prometheus\_web\_config) | n/a | `map` | `{}` | no |
| <a name="input_grafana_disk_size"></a> [grafana\_disk\_size](#input\_grafana\_disk\_size) | n/a | `string` | `"10Gi"` | no |
| <a name="input_grafana_image"></a> [grafana\_image](#input\_grafana\_image) | n/a | `string` | `"grafana/grafana:6.4.3"` | no |
| <a name="input_grafana_password"></a> [grafana\_password](#input\_grafana\_password) | Password is generated if not supplied | `string` | `""` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"default"` | no |
| <a name="input_prometheus_disk_size"></a> [prometheus\_disk\_size](#input\_prometheus\_disk\_size) | n/a | `string` | `"10Gi"` | no |
| <a name="input_prometheus_image"></a> [prometheus\_image](#input\_prometheus\_image) | n/a | `string` | `"prom/prometheus:v2.37.0"` | no |
| <a name="input_prometheus_password"></a> [prometheus\_password](#input\_prometheus\_password) | Password is generated if not supplied | `string` | `""` | no |
| <a name="input_prometheus_scrape_configs"></a> [prometheus\_scrape\_configs](#input\_prometheus\_scrape\_configs) | n/a | `list` | `[]` | no |
| <a name="input_prometheus_user"></a> [prometheus\_user](#input\_prometheus\_user) | n/a | `string` | `"prometheus"` | no |
| <a name="input_scheme"></a> [scheme](#input\_scheme) | n/a | `string` | `"https"` | no |
| <a name="input_statsd_image"></a> [statsd\_image](#input\_statsd\_image) | n/a | `string` | `"prom/statsd-exporter:v0.22.1"` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | The k8s storage class to use in provisioning persistent volumes | `string` | n/a | yes |
| <a name="input_url"></a> [url](#input\_url) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
