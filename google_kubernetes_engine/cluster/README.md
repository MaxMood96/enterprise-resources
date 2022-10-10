## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.39.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_global_address.private_ip_alloc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_network.codecov](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.codecov](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.web](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.worker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_project_iam_custom_role.storage_create](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.postgres](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.storage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_redis_instance.codecov](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance) | resource |
| [google_service_account.minio](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.postgres](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.minio](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_service_account_key.postgres](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_service_networking_connection.nat_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_sql_database.codecov](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.codecov](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.codecov](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_storage_bucket.minio](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.minio](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_hmac_key.minio](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_hmac_key) | resource |
| [random_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_string.postgres-password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_container_engine_versions.gke](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_engine_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_authorized_cidrs"></a> [cluster\_authorized\_cidrs](#input\_cluster\_authorized\_cidrs) | Map of cidr ranges to allow access to the cluster endopint. | `map(string)` | `{}` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection on the database | `bool` | `true` | no |
| <a name="input_gcloud_project"></a> [gcloud\_project](#input\_gcloud\_project) | Google cloud project | `string` | n/a | yes |
| <a name="input_minio_bucket_force_destroy"></a> [minio\_bucket\_force\_destroy](#input\_minio\_bucket\_force\_destroy) | Force is required to destroy the cloud sql bucket when it contains data | `bool` | `true` | no |
| <a name="input_minio_bucket_location"></a> [minio\_bucket\_location](#input\_minio\_bucket\_location) | Location of GCS bucket | `string` | `"US"` | no |
| <a name="input_minio_bucket_name"></a> [minio\_bucket\_name](#input\_minio\_bucket\_name) | Name of GCS bucket to create for minio | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use on resources, GKE, DB, REDIS, GCS | `string` | `"codecov-enterprise"` | no |
| <a name="input_node_pool_machine_type"></a> [node\_pool\_machine\_type](#input\_node\_pool\_machine\_type) | Machine type to use for the default node pool | `string` | `"n1-standard-1"` | no |
| <a name="input_node_pool_worker_machine_type"></a> [node\_pool\_worker\_machine\_type](#input\_node\_pool\_worker\_machine\_type) | Machine type to use for the worker node pool | `string` | `"n1-standard-4"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Instance type used for postgres instance | `string` | `"db-f1-micro"` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | n/a | `string` | `"POSTGRES_14"` | no |
| <a name="input_redis_memory_size"></a> [redis\_memory\_size](#input\_redis\_memory\_size) | Memory size in GB for redis instance | `number` | `1` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | n/a | `string` | `"REDIS_6_X"` | no |
| <a name="input_region"></a> [region](#input\_region) | Google cloud region | `string` | `"us-east1"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | n/a | `map(any)` | <pre>{<br>  "application": "codecov",<br>  "environment": "test"<br>}</pre> | no |
| <a name="input_web_node_pool_count"></a> [web\_node\_pool\_count](#input\_web\_node\_pool\_count) | Number of nodes to create in the default node pool. If you use a regional cluster, this will be multiplied by 3. X per zone. | `number` | `1` | no |
| <a name="input_web_spot_enabled"></a> [web\_spot\_enabled](#input\_web\_spot\_enabled) | Whether to use spot nodes for web node pool | `bool` | `false` | no |
| <a name="input_worker_node_pool_count"></a> [worker\_node\_pool\_count](#input\_worker\_node\_pool\_count) | Number of nodes to create in the default node pool | `number` | `1` | no |
| <a name="input_worker_spot_enabled"></a> [worker\_spot\_enabled](#input\_worker\_spot\_enabled) | Whether to use spot nodes for worker node pool. If you use a regional cluster, this will be multiplied by 3. X per zone. | `bool` | `true` | no |
| <a name="input_zonal_cluster_enabled"></a> [zonal\_cluster\_enabled](#input\_zonal\_cluster\_enabled) | Whether to create a zonal cluster for GKE (1 zone vs 1 region) | `bool` | `false` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone to create GKE clusetr in if zonal\_cluster\_enabled is true | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_cluster_primary_endpoint"></a> [cluster\_primary\_endpoint](#output\_cluster\_primary\_endpoint) | n/a |
| <a name="output_google_project"></a> [google\_project](#output\_google\_project) | n/a |
| <a name="output_minio_access_key"></a> [minio\_access\_key](#output\_minio\_access\_key) | n/a |
| <a name="output_minio_domain"></a> [minio\_domain](#output\_minio\_domain) | n/a |
| <a name="output_minio_name"></a> [minio\_name](#output\_minio\_name) | n/a |
| <a name="output_minio_secret_key"></a> [minio\_secret\_key](#output\_minio\_secret\_key) | n/a |
| <a name="output_nat_address"></a> [nat\_address](#output\_nat\_address) | n/a |
| <a name="output_postgres_ip"></a> [postgres\_ip](#output\_postgres\_ip) | n/a |
| <a name="output_postgres_pw"></a> [postgres\_pw](#output\_postgres\_pw) | n/a |
| <a name="output_postgres_server_name"></a> [postgres\_server\_name](#output\_postgres\_server\_name) | n/a |
| <a name="output_postgres_username"></a> [postgres\_username](#output\_postgres\_username) | n/a |
| <a name="output_redis_hostname"></a> [redis\_hostname](#output\_redis\_hostname) | n/a |
| <a name="output_redis_password"></a> [redis\_password](#output\_redis\_password) | n/a |
| <a name="output_redis_port"></a> [redis\_port](#output\_redis\_port) | n/a |
