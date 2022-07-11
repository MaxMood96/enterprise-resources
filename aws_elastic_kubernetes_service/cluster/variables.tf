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
  default     = "codecov-cluster"
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

variable "ingress_host" {
  description = "Hostname used for http(s) ingress"
}

variable "resource_tags" {
  type = map(any)
  default = {
    application = "codecov"
    environment = "test"
  }
}

variable "ingress_enabled" {
  description = "Whether to create an ALB ingress for Codecov"
  default     = true
}

variable "elasticache_version" {
  default = "6.2"
}
variable "postgres_version" {
  default = "14.2"
}
variable "dns_enabled" {
  description = "Whether to create route53 records for Codecov"
  default     = false
}
variable "cert_enabled" {
  description = "Whether to create an ACM cert for Codecov. Only works with dns enabled"
  default     = true
}
variable "cert_san" {
  description = "ACM cert Subject Alternative Names"
  default     = []
}
variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID to enable DNS to your Codecov install"
  default     = ""
}

variable "ingress_namespace" {
  description = "Namespace that the ingress will be created in"
  default     = "default"
}

variable "codecov_namespace" {
  description = "Namespace that Codecov will be created in"
  default     = "codecov"
}

variable "vpc_name" {
  description = "The name of the vpc to create. This must match the vpc_name var in k8s-config template"
  default     = "codecov-vpc"
}