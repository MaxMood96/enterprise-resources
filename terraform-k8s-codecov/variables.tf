variable "codecov_version" {
  description = "Version of Codecov Enterprise to deploy"
  default     = "latest-stable"
}

variable "web_replicas" {
  description = "Number of web replicas to deploy"
  default     = "2"
}

variable "api_replicas" {
  description = "Number of api replicas to deploy"
  default     = "2"
}

variable "worker_replicas" {
  description = "Number of worker replicas to deploy"
  default     = "2"
}


variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
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

# 
variable "scm_ca_cert" {
  description = "SCM CA certificate path"
  default     = ""
}
variable "namespace" {
  type    = string
  default = "codecov"
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
variable "postgres_username" {
  type = string
}
variable "postgres_url" {
  type = string
}
variable "postgres_password" {
  type = string
}
variable "postgres_host" {
  type = string
}
variable "redis_url" {
  type = string
}

variable "minio_domain" {
  type = string
}
variable "common_env" {
  type = map
}
variable "common_secret_env" {
  type = map
}
variable "codecov_yml_file" {
  type = any
}