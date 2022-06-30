variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "codecov_version" {
  description = "Version of codecov enterprise to deploy"
  default     = "latest-stable"
}

variable "cluster_name" {
  description = "Google Kubernetes Engine (GKE) cluster name"
  default     = "default-codecov-cluster"
}

variable "postgres_instance_class" {
  description = "Instance class for PostgreSQL RDS instance"
  default     = "db.t3.medium"
}

variable "postgres_skip_final_snapshot" {
  type        = bool
  description = "Whether to skip taking a final snapshot when destroying the Postgres DB"
  default     = "true"
}

variable "redis_node_type" {
  description = "Node type to use for redis cluster nodes"
  default     = "cache.t3.small"
}

variable "redis_num_nodes" {
  description = "Number of nodes to run in the redis cluster"
  default     = "1"
}

variable "web_nodes" {
  description = "Number of web nodes to create"
  default     = "2"
}

variable "web_node_type" {
  description = "Instance type to use for web nodes"
  default     = "t3.medium"
}

variable "worker_nodes" {
  description = "Number of worker nodes to create"
  default     = "2"
}

variable "worker_node_type" {
  description = "Instance type to use for worker nodes"
  default     = "t3.large"
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

variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}

variable "scm_ca_cert" {
  description = "SCM CA certificate path"
  default     = ""
}
