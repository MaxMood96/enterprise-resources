variable "namespace" {
  type    = string
  default = "codecov"
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

variable "codecov_version" {
  description = "Version of codecov enterprise to deploy"
  default     = "latest-stable"
}
variable "statsd_enabled" {
  type    = bool
  default = false
}

variable "enable_external_tls" {
  description = "use if you have your own certificate and input tls_key and tls_cert"
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

variable "codecov_yml" {
  description = "Path to your codecov.yml"
  default     = "../../codecov.yml"
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

variable "dns_enabled" {
  type        = bool
  default     = false
  description = "Attempt to create a DNS record for the ingress. Requires the ingress to be enabled and dns_zone to be set to a valid dns zone"
}
variable "dns_zone" {
  type    = string
  default = ""
}
variable "root_domain" {
  type        = bool
  default     = false
  description = "Set to true if your Codecov url is the root of your dns zone"
}

variable "domain" {
  type        = string
  default     = ""
  description = "The domain that your app is hosted on. E.g. codecov.io. This is used for minio dns. minio.codecov.io for example"
}
variable "letsencrypt_email" {
  type        = string
  description = "Email to use with letsencrypt. This is required if enable_certmanager is enabled"
  default     = ""
}
variable "ingress_enabled" {
  default     = true
  type        = bool
  description = "Deploy nginx ingress?"
}
variable "enable_certmanager" {
  description = "enables lets encrypt and creates certificate request based off codecov url in codecov.yml file"
  default     = true
}
variable "extra_env" {
  default     = {}
  description = "Map of extra environment variables to add"
}
variable "extra_secret_env" {
  default     = {}
  description = "Map of extra environment variables to add as a secret and them source from the secret"
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