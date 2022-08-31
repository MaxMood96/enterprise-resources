provider "aws" {
  region = var.region
}
provider "aws" {
  region  = var.route53_region
  profile = var.route53_profile
  alias   = "route53"
}