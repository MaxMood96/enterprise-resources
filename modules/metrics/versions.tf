terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = "0.1.2"
    }
  }
  required_version = ">= 0.13"
}