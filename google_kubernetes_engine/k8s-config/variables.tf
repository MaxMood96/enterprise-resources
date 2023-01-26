
variable "gcloud_project" {
  description = "Google cloud project"
  default     = ""
}
variable "enable_external_tls" {
  description = "use if you have your own certificate and input tls_key and tls_cert"
  default     = "0"
}
variable "namespace" {
  description = "Namespace to deploy Codecov into"
  default     = "codecov"
}
variable "statsd_enabled" {
  default = false
}
variable "root_domain" {
  default = true
}
variable "dns_enabled" {
  default = true
}
variable "ingress_enabled" {
  default = true
}
variable "cert_enabled" {
  default = true
}

// Example extra volume for GH App pem
//extra_secret_volumes = {
//  gh = {
//    mount_path = "/gh"
//    file_name = "codecov.pem"
//    local_path = "/secrets/codecov.pem"
//  }
//}
// Example extra volume for SCM CA Cert
//extra_secret_volumes = {
//  scm = {
//    mount_path = "/cert"
//    file_name = "scm_ca_cert.pem"
//    local_path = "/secrets/CA.pem"
//  }
//}
variable "extra_env" {
  default     = {}
  description = "Map of extra environment variables to add"
}

variable "extra_secret_volumes" {
  default     = {}
  description = "Map of extra volumes to mount to the Codecov deployments. This is primarily used to mount github app integration secret key."
  validation {
    condition = alltrue(
      [for o in var.extra_secret_volumes : (length(lookup(o, "mount_path", "")) > 0)]
    )
    error_message = "All extra volumes must have a mount_path to mount in the containers"
  }
  validation {
    condition = alltrue(
      [for o in var.extra_secret_volumes : (length(lookup(o, "local_path", "")) > 0)],
    )
    error_message = "All extra volumes must have a local_path to load a file from"
  }
  validation {
    condition = alltrue(
      [for o in var.extra_secret_volumes : fileexists(lookup(o, "local_path", "DOES_NOT_EXIST"))]
    )
    error_message = "Local file must exist to load into secret"
  }
  validation {
    condition = alltrue(
      [for o in var.extra_secret_volumes : (length(lookup(o, "file_name", "")) > 0)],
    )
    error_message = "All extra volumes must have a file_name to assign in the secret"
  }
}
variable "extra_secret_env" {
  default     = {}
  description = "Map of extra environment variables to add as a secret and them source from the secret"
}
variable "region" {
  description = "Google cloud region"
  default     = "us-east4"
}
variable "dns_region" {
  description = "Google cloud region"
  default     = "us-east4"
}

variable "zone" {
  description = "Default Google cloud zone for zone-specific services"
  default     = "us-east4a"
}

variable "codecov_version" {
  description = "Version of codecov enterprise to deploy"
  default     = "latest-stable"
}

variable "cluster_name" {
  description = "Google Kubernetes Engine (GKE) cluster name"
  default     = "default-codecov-cluster"
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

variable "web_resources" {
  type = map(any)
  default = {
    replicas       = 2
    cpu_limit      = "1000m"
    memory_limit   = "2048M"
    cpu_request    = "150m"
    memory_request = "128M"
  }
}

variable "api_resources" {
  type = map(any)
  default = {
    replicas       = 2
    cpu_limit      = "1000m"
    memory_limit   = "2048M"
    cpu_request    = "250m"
    memory_request = "256M"
  }
}

variable "worker_resources" {
  type = map(any)
  default = {
    replicas       = 2
    cpu_limit      = "3000m"
    memory_limit   = "1024M"
    cpu_request    = "500m"
    memory_request = "1024M"
  }
}

/*
variable "minio_bucket_name" {
  description = "Name of GCS bucket to create for minio"
}*/

variable "minio_bucket_location" {
  description = "Location of GCS bucket"
  default     = "US"
}

variable "minio_bucket_force_destroy" {
  description = "Force is required to destroy the cloud sql bucket when it contains data"
  default     = "false"
}

variable "redis_memory_size" {
  description = "Memory size in GB for redis instance"
  default     = "5"
}

variable "postgres_instance_type" {
  description = "Instance type used for postgres instance"
  default     = "db-f1-micro"
}

variable "codecov_yml" {
  description = "Path to your codecov.yml"
  default     = "../../codecov.yml"
}
variable "dns_zone" {
  description = "Dns zone"
  default     = ""
}
variable "dns_project" {
  description = "Project that DNS zone resides in"
  default     = ""
}

variable "ingress_host" {
  description = "Hostname used for http(s) ingress"
}


variable "enable_https" {
  description = "Enables https ingress.  Requires TLS cert and key"
  default     = "0"
}

variable "tls_key" {
  description = "Path to private key to use for TLS"
  default     = ""
}

variable "tls_cert" {
  description = "Path to certificate to use for TLS"
  default     = ""
}

variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}

variable "dns_credentials" {
  default     = ""
  description = "Filepath to gcp service account json key to manage dns. Only needed if dns is enabled. There is currently not a clean way to use the normal credentials while still enabling optional cross account."
}

variable "frontend_resources" {
  type = map(any)
  default = {
    replicas       = 2
    cpu_limit      = "1000m"
    memory_limit   = "2048M"
    cpu_request    = "150m"
    memory_request = "128M"
  }
}
variable "gateway_resources" {
  type = map(any)
  default = {
    replicas       = 2
    cpu_limit      = "1000m"
    memory_limit   = "2048M"
    cpu_request    = "150m"
    memory_request = "128M"
  }
}
variable "codecov_repository" {
  default     = "codecov"
  description = "Docker repository to retrieve Codecov images"
}
variable "api_image" {
  default = "enterprise-api"
}
variable "frontend_image" {
  default = "enterprise-frontend"
}
variable "worker_image" {
  default = "enterprise-worker"
}
variable "gateway_image" {
  default = "enterprise-gateway"
}
variable "worker_args" {
  default     = ["worker", "--queue", "celery,uploads", "--concurrency", "1"]
  description = "Args to send to worker. This usually doesn't need to be adjusted."
}