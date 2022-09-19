variable "dns_name" {}
variable "zone_name" {}
variable "record" {}
variable "root_domain" {
  type = bool
  description = "Whether to create the dns record as an apex record"
  default = false
}