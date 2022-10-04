variable "codecov_version" {
  description = "Version of Codecov Enterprise to deploy"
  default     = "latest-stable"
}

variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
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

variable "minio_resources" {
  type = map(any)
  default = {
    replicas       = 2
    cpu_limit      = "256m"
    memory_limit   = "512M"
    cpu_request    = "32m"
    memory_request = "64M"
  }
}

variable "namespace" {
  type    = string
  default = "codecov"
}
variable "extra_env" {
  default     = {}
  description = "Map of extra environment variables to add"
}
variable "extra_secret_env" {
  default     = {}
  description = "Map of extra environment variables to add as a secret and them source from the secret"
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
variable "statsd_enabled" {
  type    = bool
  default = false
}
variable "postgres_url" {
  type = string
}
variable "redis_url" {
  type = string
}

variable "minio_domain" {
  type = string
}
variable "codecov_yml_file" {
  type    = any
  default = "../codecov.yml"
}
variable "enable_certmanager" {
  description = "enables lets encrypt and creates certificate request based off codecov url in codecov.yml file"
  default     = false
}
variable "enable_external_tls" {
  description = "use if you have your own certificate and input tls_key and tls_cert"
  default     = false
}
variable "ingress_enabled" {
  default     = true
  type        = bool
  description = "Deploy nginx ingress?"
}
variable "letsencrypt_server" {
  type    = string
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "letsencrypt_email" {
  type        = string
  description = "Email to use with letsencrypt. This is required if enable_certmanager is enabled"
  default     = ""
}

variable "tls_key" {
  description = "Path to private key to use for TLS"
  default     = ""
}

variable "tls_cert" {
  description = "Path to certificate to use for TLS"
  default     = ""
}
variable "minio_bucket" {
  description = "The name of the s3 bucket / GCS bucket / Azure storage account to use to store reports"
  type        = string
}
variable "minio_enabled" {
  description = "Enable to deploy minio into the cluster"
  default     = false
  type        = string
}
variable "service_account_annotations" {
  type        = map(string)
  default     = {}
  description = "Annotations to add to the codecov service account"
}
variable "web_service_type" {
  default = "NodePort"
}