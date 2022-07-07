terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.route53]
    }
  }
  required_version = ">= 0.13"
}