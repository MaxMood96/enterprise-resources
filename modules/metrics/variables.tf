variable "namespace" {
  default = "default"
}

variable "create_namespace" {
  type    = bool
  default = false
}

variable "annotations" {
  default = {}
}

variable "statsd_image" {
  type    = string
  default = "prom/statsd-exporter:v0.22.1"
}
variable "prometheus_image" {
  type    = string
  default = "prom/prometheus:v2.37.0"
}
variable "grafana_image" {
  type    = string
  default = "grafana/grafana:9.3.2"
}

variable "image_pull_policy" {
  type    = string
  default = "IfNotPresent"
}

variable "prometheus_scrape_configs" {
  default = []
}

variable "extra_prometheus_config" {
  default = {}
}
variable "extra_prometheus_web_config" {
  default = {}
}



variable "url" {
  type = string
}

variable "scheme" {
  type    = string
  default = "https"
}

variable "load_balancer_type" {
  type    = string
  default = "ClusterIP"
}

variable "prometheus_user" {
  type    = string
  default = "prometheus"
}

variable "prometheus_password" {
  type        = string
  default     = ""
  description = "Password is generated if not supplied"
}

variable "grafana_password" {
  type        = string
  default     = ""
  description = "Password is generated if not supplied"
}

variable "storage_class_name" {
  type        = string
  description = "The k8s storage class to use in provisioning persistent volumes"
}

variable "grafana_disk_size" {
  default = "10Gi"
  type    = string
}

variable "prometheus_disk_size" {
  default = "10Gi"
  type    = string
}
