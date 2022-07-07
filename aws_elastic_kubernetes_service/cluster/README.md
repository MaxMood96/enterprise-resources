# Codecov Cluster
This is an example Codecov stack deployed to AWS Elastic Kubernetes Service via
terraform.  It consists of:
- A VPC
- Public and private subnets spanning for each of 3 availability zones.
- An EKS kubernetes cluster
- An RDS Postgres instance
- An Elasticache Redis instance
- An S3 bucket for coverage report storage.

This is part 1 of the Codecov deployment. It deploys the majority of the AWS resources including the EKS cluster.

### Instance Types

The default instance types and number of instances are the minimum to get
the Codecov application up and running.  Tuning these will be required,
dependent on your specific use-case.

### Granting Codecov access to internal resources

If your organization requires creating firewall rules to grant Codecov access
to your internal resources, the IP address for the NAT gateway can be found in
the terraform output.  All requests from Codecov Enterprise will originate from
this address.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.21.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert"></a> [cert](#module\_cert) | ./modules/cert | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> v2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_elasticache_cluster.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.minio-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codecov](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.minio-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.minio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.minio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_secretsmanager_secret.connections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.connections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.eks-postgres-out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks-redis-out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_pet.minio-bucket-suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_string.identifier-suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.postgres-password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_availability_zones.list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.alb_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codecov-eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ingress-oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.minio-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_enabled"></a> [cert\_enabled](#input\_cert\_enabled) | Whether to create an ACM cert for Codecov. Only works with dns enabled | `bool` | `true` | no |
| <a name="input_cert_san"></a> [cert\_san](#input\_cert\_san) | ACM cert Subject Alternative Names | `list` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Google Kubernetes Engine (GKE) cluster name | `string` | `"codecov-cluster"` | no |
| <a name="input_codecov_namespace"></a> [codecov\_namespace](#input\_codecov\_namespace) | Namespace that Codecov will be created in | `string` | `"codecov"` | no |
| <a name="input_codecov_version"></a> [codecov\_version](#input\_codecov\_version) | Version of codecov enterprise to deploy | `string` | `"latest-stable"` | no |
| <a name="input_dns_enabled"></a> [dns\_enabled](#input\_dns\_enabled) | Whether to create route53 records for Codecov | `bool` | `false` | no |
| <a name="input_elasticache_version"></a> [elasticache\_version](#input\_elasticache\_version) | n/a | `string` | `"6.2"` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route53 Hosted Zone ID to enable DNS to your Codecov install | `string` | `""` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Whether to create an ALB ingress for Codecov | `bool` | `true` | no |
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | Hostname used for http(s) ingress | `any` | n/a | yes |
| <a name="input_ingress_namespace"></a> [ingress\_namespace](#input\_ingress\_namespace) | Namespace that the ingress will be created in | `string` | `"default"` | no |
| <a name="input_postgres_instance_class"></a> [postgres\_instance\_class](#input\_postgres\_instance\_class) | Instance class for PostgreSQL RDS instance | `string` | `"db.t3.medium"` | no |
| <a name="input_postgres_skip_final_snapshot"></a> [postgres\_skip\_final\_snapshot](#input\_postgres\_skip\_final\_snapshot) | Whether to skip taking a final snapshot when destroying the Postgres DB | `bool` | `"true"` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | n/a | `string` | `"14.2"` | no |
| <a name="input_redis_node_type"></a> [redis\_node\_type](#input\_redis\_node\_type) | Node type to use for redis cluster nodes | `string` | `"cache.t3.small"` | no |
| <a name="input_redis_num_nodes"></a> [redis\_num\_nodes](#input\_redis\_num\_nodes) | Number of nodes to run in the redis cluster | `string` | `"1"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | n/a | `map(any)` | <pre>{<br>  "application": "codecov",<br>  "environment": "test"<br>}</pre> | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the vpc to create. This must match the vpc\_name var in k8s-config template | `string` | `"codecov-vpc"` | no |
| <a name="input_web_node_type"></a> [web\_node\_type](#input\_web\_node\_type) | Instance type to use for web nodes | `string` | `"t3.medium"` | no |
| <a name="input_web_nodes"></a> [web\_nodes](#input\_web\_nodes) | Number of web nodes to create | `string` | `"2"` | no |
| <a name="input_worker_node_type"></a> [worker\_node\_type](#input\_worker\_node\_type) | Instance type to use for worker nodes | `string` | `"t3.large"` | no |
| <a name="input_worker_nodes"></a> [worker\_nodes](#input\_worker\_nodes) | Number of worker nodes to create | `string` | `"2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_ips"></a> [nat\_gateway\_ips](#output\_nat\_gateway\_ips) | Include NAT gateway public IP(s) in output if required for firewall rules / access restrictions |
