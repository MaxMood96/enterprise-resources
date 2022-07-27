variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "eastus"
}
/*
variable "azurerm_client_id" {
  description = "Azure service principal client id to use for kubernetes cluster"
}

variable "azurerm_client_secret" {
  description = "Azure service principal client secret to use for kubernetes cluster"
}*/

variable "codecov_version" {
  description = "Version of codecov enterprise to deploy"
  default     = "latest-stable"
}

variable "cluster_name" {
  description = "Azure Kubernetes Service (AKS) cluster name"
  default     = "codecov-enterprise"
}

variable "node_pool_count" {
  description = "The number of nodes to execute in the kubernetes node pool"
  default     = "5"
}

variable "node_pool_vm_size" {
  description = "The vm size to use for the node pool instances"
  default     = "Standard_B2s"
}

variable "postgres_sku" {
  description = "PostgreSQL DB SKU"
  default     = "GP_Gen5_2"
}

variable "postgres_storage_profile" {
  description = "Storage profile for PostgreSQL DB"
  default = {
    storage_mb                   = "5120"
    backup_retention_days        = "7"
    geo_redundant_backup_enabled = "false"
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

variable "traefik_resources" {
  type = map(any)
  default = {
    replicas       = 2
    cpu_limit      = "500m"
    memory_limit   = "512M"
    cpu_request    = "50m"
    memory_request = "64M"
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

variable "enable_traefik" {
  description = "Whether or not to include Traefik ingress"
  default     = "1"
}

variable "codecov_yml" {
  description = "Path to your codecov.yml"
  default     = "codecov.yml"
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

variable "ssh_public_key" {
  description = "SSH key to install on k8s cluster instances"
}

variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}

# 
variable "scm_ca_cert" {
  description = "SCM CA certificate path"
  default     = ""
}
