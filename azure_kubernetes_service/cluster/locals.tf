locals {
  codecov_url = yamldecode(file(var.codecov_yml))
}