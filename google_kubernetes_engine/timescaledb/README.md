## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | 1.18.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.47.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.internal-address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.internal-address-replication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_firewall.firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.firewall-pods_cidr](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.firewall-replication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.timescale_db_server](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_instance.timescale_db_server_primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_instance.timescale_db_server_secondary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_storage_bucket.postgres_backups](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |
| [random_string.timescale](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/string) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_compute_subnetwork.my-subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_delete"></a> [auto\_delete](#input\_auto\_delete) | Where the disk will be autodeleted when the instance is deleted | `bool` | `true` | no |
| <a name="input_enable_integrity_monitoring"></a> [enable\_integrity\_monitoring](#input\_enable\_integrity\_monitoring) | enable integrity monitoring | `bool` | `true` | no |
| <a name="input_enable_secure_boot"></a> [enable\_secure\_boot](#input\_enable\_secure\_boot) | enable secure boot | `bool` | `true` | no |
| <a name="input_enable_vtpm"></a> [enable\_vtpm](#input\_enable\_vtpm) | enable vtpm | `bool` | `true` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Describes machine\_types | `string` | `"e2-small"` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | ssh keys | `map` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | naming convention for things | `string` | `"codecov-enterprise"` | no |
| <a name="input_postgres_skip_final_snapshot"></a> [postgres\_skip\_final\_snapshot](#input\_postgres\_skip\_final\_snapshot) | Whether to skip taking a final snapshot when destroying the Postgres DB | `bool` | `"true"` | no |
| <a name="input_prepend_userdata"></a> [prepend\_userdata](#input\_prepend\_userdata) | allows you to add to scripts | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"us-east1"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | service\_account\_email | `string` | `""` | no |
| <a name="input_source_inbound_ranges"></a> [source\_inbound\_ranges](#input\_source\_inbound\_ranges) | Should be all ingress addresses for timescale | `list` | `[]` | no |
| <a name="input_source_ranges"></a> [source\_ranges](#input\_source\_ranges) | n/a | `string` | `""` | no |
| <a name="input_storage_account_region"></a> [storage\_account\_region](#input\_storage\_account\_region) | region for storage account | `string` | `"US"` | no |
| <a name="input_subnet_range"></a> [subnet\_range](#input\_subnet\_range) | subnet range for VM | `string` | `"10.0.1.0\\24"` | no |
| <a name="input_timescale_server_replication_enabled"></a> [timescale\_server\_replication\_enabled](#input\_timescale\_server\_replication\_enabled) | is replication enabled | `bool` | `false` | no |
| <a name="input_userdata"></a> [userdata](#input\_userdata) | n/a | `map` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | GCP zone | `string` | `"us-east1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_timescale_db_ip_primary"></a> [timescale\_db\_ip\_primary](#output\_timescale\_db\_ip\_primary) | n/a |
| <a name="output_timescale_db_ip_secondary"></a> [timescale\_db\_ip\_secondary](#output\_timescale\_db\_ip\_secondary) | n/a |
| <a name="output_timescale_db_ip_single_server"></a> [timescale\_db\_ip\_single\_server](#output\_timescale\_db\_ip\_single\_server) | n/a |
| <a name="output_timescale_url"></a> [timescale\_url](#output\_timescale\_url) | n/a |
