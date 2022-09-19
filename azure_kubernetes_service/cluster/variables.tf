variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "eastus"
}

variable "azurerm_client_id" {
  description = "Azure service principal client id to use for kubernetes cluster"
  default     = "$ARM_CLIENT_ID"
}

variable "azurerm_client_secret" {
  description = "Azure service principal client secret to use for kubernetes cluster"
  default     = "$ARM_CLIENT_SECRET"
}

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

variable "ssh_public_key" {
  description = "SSH key to install on k8s cluster instances"
  default     = "~/.ssh/id_rsa.pub"
}

variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}