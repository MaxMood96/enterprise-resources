# Codecov K8s Config
This is an example Codecov stack deployed to AWS Elastic Kubernetes Service via
terraform.  It consists of:
- Web Deployment
- Worker Deployment
- Api Deployment
- Ingress Deployment
- Kubernetes resources to support these deployments

This is part 2 of the Codecov deployment. It deploys all of the kubernetes resources and handles dns if enabled.
A secondary run of this template will need to be done once the ingress has been created. On the first run it will not have the hostname.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.21.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [kubernetes_cluster_role.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_deployment.api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.worker](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_ingress_v1.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.codecov](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.codecov-yml](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.scm-ca-cert](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service_account.codecov](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_service_account.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_role.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_secretsmanager_secret.connections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.connections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_resources"></a> [api\_resources](#input\_api\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "1000m",<br>  "cpu_request": "250m",<br>  "memory_limit": "2048M",<br>  "memory_request": "256M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_cert_enabled"></a> [cert\_enabled](#input\_cert\_enabled) | Whether to create an ACM cert for Codecov. Only works with dns enabled | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Google Kubernetes Engine (GKE) cluster name | `string` | `"codecov-cluster"` | no |
| <a name="input_codecov_namespace"></a> [codecov\_namespace](#input\_codecov\_namespace) | Namespace to deploy Codecov into | `string` | `"codecov"` | no |
| <a name="input_codecov_version"></a> [codecov\_version](#input\_codecov\_version) | Version of codecov enterprise to deploy | `string` | `"latest-stable"` | no |
| <a name="input_codecov_yml"></a> [codecov\_yml](#input\_codecov\_yml) | Path to your codecov.yml | `string` | `"codecov.yml"` | no |
| <a name="input_dns_enabled"></a> [dns\_enabled](#input\_dns\_enabled) | Whether to create route53 records for Codecov | `bool` | `false` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route53 Hosted Zone ID to enable DNS to your Codecov install | `string` | `""` | no |
| <a name="input_ingress_controller_version"></a> [ingress\_controller\_version](#input\_ingress\_controller\_version) | The AWS ALB Ingress Controller version to use. See https://github.com/kubernetes-sigs/aws-alb-ingress-controller/releases for available versions | `string` | `"2.4.2"` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Whether to create an ALB ingress for Codecov | `bool` | `true` | no |
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | Hostname used for http(s) ingress | `any` | n/a | yes |
| <a name="input_ingress_namespace"></a> [ingress\_namespace](#input\_ingress\_namespace) | Namespace to create the ingress in | `string` | `"default"` | no |
| <a name="input_ingress_pod_annotations"></a> [ingress\_pod\_annotations](#input\_ingress\_pod\_annotations) | Additional annotations to be added to the Pods. | `map(string)` | `{}` | no |
| <a name="input_ingress_pod_labels"></a> [ingress\_pod\_labels](#input\_ingress\_pod\_labels) | Additional labels to be added to the Pods. | `map(string)` | `{}` | no |
| <a name="input_ingress_replicas"></a> [ingress\_replicas](#input\_ingress\_replicas) | Amount of replicas to be created. | `number` | `1` | no |
| <a name="input_ingress_scheme"></a> [ingress\_scheme](#input\_ingress\_scheme) | internal or internet-facing alb | `string` | `"internet-facing"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | n/a | `map(any)` | <pre>{<br>  "application": "codecov",<br>  "environment": "test"<br>}</pre> | no |
| <a name="input_scm_ca_cert"></a> [scm\_ca\_cert](#input\_scm\_ca\_cert) | SCM CA certificate path | `string` | `""` | no |
| <a name="input_statsd_enabled"></a> [statsd\_enabled](#input\_statsd\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the vpc that was created. This must match the vpc\_name var in cluster template | `string` | `"codecov-vpc"` | no |
| <a name="input_web_resources"></a> [web\_resources](#input\_web\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "1000m",<br>  "cpu_request": "150m",<br>  "memory_limit": "2048M",<br>  "memory_request": "128M",<br>  "replicas": 2<br>}</pre> | no |
| <a name="input_worker_resources"></a> [worker\_resources](#input\_worker\_resources) | n/a | `map(any)` | <pre>{<br>  "cpu_limit": "3000m",<br>  "cpu_request": "500m",<br>  "memory_limit": "1024M",<br>  "memory_request": "1024M",<br>  "replicas": 2<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_hostname"></a> [ingress\_hostname](#output\_ingress\_hostname) | n/a |

* Specifying a codecov_version is recommended and requires the format `v$VERSION` e.g. `v4.5.8`

### `scm_ca_cert`

If `scm_ca_cert` is configured, it will be available to Codecov at
`/cert/scm_ca_cert.pem`.  Include this path in your `codecov.yml` in the scm
config.