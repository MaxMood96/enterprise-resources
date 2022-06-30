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

variable "codecov_yml" {
  description = "Location of your codecov.yml file"
}

variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}

variable "web_resources" {
  type = map(any)
  default = {
    cpu_limit      = "1000m"
    memory_limit   = "2048M"
    cpu_request    = "150m"
    memory_request = "128M"
  }
}

variable "api_resources" {
  type = map(any)
  default = {
    cpu_limit      = "1000m"
    memory_limit   = "2048M"
    cpu_request    = "250m"
    memory_request = "256M"
  }
}

variable "worker_resources" {
  type = map(any)
  default = {
    cpu_limit      = "3000m"
    memory_limit   = "1024M"
    cpu_request    = "500m"
    memory_request = "1024M"
  }
}

# 
variable "scm_ca_cert" {
  description = "SCM CA certificate path"
  default     = ""
}
