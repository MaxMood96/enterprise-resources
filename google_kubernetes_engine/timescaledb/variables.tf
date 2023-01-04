variable "zone" {
  description = "GCP zone"
  default     = "us-east1-b"
}

variable "region" {
  description = "GCP region"
  default     = "us-east1"
}

variable "auto_delete" {
  description = "Where the disk will be autodeleted when the instance is deleted"
  default     = true
}
variable "userdata" {
  description = ""
  default     = {}
}
variable "subnet_range" {
  description = "subnet range for VM"
  default     = "10.0.1.0\\24"
}
variable "metadata" {
  description = "ssh keys"
  default     = {}
}
variable "source_ranges" {
  default     = ""
  description = ""
}
variable "source_inbound_ranges" {
  default     = ""
  description = "Should be all ingress addresses for timescale"
}
variable "name" {
  default     = "codecov-enterprise"
  description = "naming convention for things"
}

variable "service_account_email" {
  description = "service_account_email"
  default     = ""
}
variable "postgres_skip_final_snapshot" {
  type        = bool
  description = "Whether to skip taking a final snapshot when destroying the Postgres DB"
  default     = "true"
}
variable "machine_type" {
  description = "Describes machine_types"
  default     = "e2-small"
}
variable "timescale_server_replication_enabled" {
  description = "is replication enabled"
  default     = false
}

variable "enable_secure_boot" {
  description = "enable secure boot"
  default     = true
}
variable "enable_integrity_monitoring" {
  description = "enable integrity monitoring"
  default     = true
}
variable "enable_vtpm" {
  description = "enable vtpm"
  default     = true
}
variable "storage_account_region" {
  description = "region for storage account"
  default     = "US"

}

variable "prepend_userdata" {
  description = "allows you to add to scripts"
  default     = ""
}