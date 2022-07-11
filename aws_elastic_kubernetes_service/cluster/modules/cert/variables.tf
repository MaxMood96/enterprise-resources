variable "domain_name" {
  type        = string
  description = "A domain name for which the certificate should be issued"
}

variable "validation_method" {
  type        = string
  description = "Which method to use for validation. DNS or EMAIL are valid"
  default     = "DNS"
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "A list of domain that should be in the issued certificate"
  default     = []
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating anything"
}

variable "validate" {
  type    = bool
  default = true
}

variable "hosted_zone_id" {
  type    = string
  default = ""
}

variable "tags" {
  default = {}
}