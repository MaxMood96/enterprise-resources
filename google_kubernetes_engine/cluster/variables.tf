variable "gcloud_project" {
  type        = string
  description = "Google cloud project"
}
variable "region" {
  type        = string
  description = "Google cloud region"
  default     = "us-east1"
}
variable "zone" {
  type        = string
  default     = ""
  description = "Zone to create GKE clusetr in if zonal_cluster_enabled is true"
}
variable "zonal_cluster_enabled" {
  type        = bool
  description = "Whether to create a zonal cluster for GKE (1 zone vs 1 region)"
  default     = false
}
variable "name" {
  type        = string
  description = "Name to use on resources, GKE, DB, REDIS, GCS"
  default     = "codecov-enterprise"
}
variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}
variable "web_node_pool_count" {
  type        = number
  description = "Number of nodes to create in the default node pool. If you use a regional cluster, this will be multiplied by 3. X per zone."
  default     = 1
}
variable "web_spot_enabled" {
  type        = bool
  description = "Whether to use spot nodes for web node pool"
  default     = false
}
variable "worker_spot_enabled" {
  type        = bool
  description = "Whether to use spot nodes for worker node pool. If you use a regional cluster, this will be multiplied by 3. X per zone."
  default     = true
}
variable "worker_node_pool_count" {
  type        = number
  description = "Number of nodes to create in the default node pool"
  default     = 1
}
variable "node_pool_machine_type" {
  type        = string
  description = "Machine type to use for the default node pool"
  default     = "n1-standard-1"
}
variable "node_pool_worker_machine_type" {
  type        = string
  description = "Machine type to use for the worker node pool"
  default     = "n1-standard-4"
}
variable "redis_memory_size" {
  type        = number
  description = "Memory size in GB for redis instance"
  default     = 1
}
variable "postgres_instance_type" {
  type        = string
  description = "Instance type used for postgres instance"
  default     = "db-f1-micro"
}
variable "minio_bucket_name" {
  type        = string
  description = "Name of GCS bucket to create for minio"
  default     = ""
}
variable "minio_bucket_location" {
  type        = string
  description = "Location of GCS bucket"
  default     = "US"
}
variable "minio_bucket_force_destroy" {
  description = "Force is required to destroy the cloud sql bucket when it contains data"
  type        = bool
  default     = true
}
variable "postgres_version" {
  type    = string
  default = "POSTGRES_14"
}
variable "redis_version" {
  type    = string
  default = "REDIS_6_X"
}
variable "deletion_protection" {
  default     = true
  description = "Whether to enable deletion protection on the database"
  type        = bool
}
variable "cluster_authorized_cidrs" {
  type        = map(string)
  default     = {}
  description = "Map of cidr ranges to allow access to the cluster endopint."
  validation {
    condition = alltrue(
      [for k, v in var.cluster_authorized_cidrs : (length(regexall("(\\d{1,3}\\.){3}\\d{1,3}\\/\\d{1,2}", v)) > 0)]
    )
    error_message = "Values must be cidr ranges. Example: { personal = \"192.168.1.100/32\" }"
  }
}