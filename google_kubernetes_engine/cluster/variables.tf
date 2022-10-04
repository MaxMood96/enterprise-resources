
variable "gcloud_project" {
  description = "Google cloud project"
}
variable "codecov_yml" {
  description = "Path to your codecov.yml"
  default     = "codecov.yml"
}
variable "region" {
  description = "Google cloud region"
  default     = "us-east4"
}
variable "cluster_name" {
  description = "Google Kubernetes Engine (GKE) cluster name"
  default     = "codecov-cluster"
}
variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}
variable "web_node_pool_count" {
  description = "Number of nodes to create in the default node pool"
  default     = "1"
}
variable "worker_node_pool_count" {
  description = "Number of nodes to create in the default node pool"
  default     = "1"
}

variable "node_pool_machine_type" {
  description = "Machine type to use for the default node pool"
  default     = "n1-standard-1"
}
variable "node_pool_worker_machine_type" {
  description = "Machine type to use for the worker node pool"
  default     = "n1-standard-4"
}
variable "redis_memory_size" {
  description = "Memory size in GB for redis instance"
  default     = "1"
}

variable "postgres_instance_type" {
  description = "Instance type used for postgres instance"
  default     = "db-f1-micro"
}
variable "minio_bucket_name" {
  description = "Name of GCS bucket to create for minio"
}

variable "minio_bucket_location" {
  description = "Location of GCS bucket"
  default     = "US"
}

variable "minio_bucket_force_destroy" {
  description = "Force is required to destroy the cloud sql bucket when it contains data"
  default     = "false"
}
variable "zone" {
  description = "name of region"
  default     = "us-east1"
}