data "terraform_remote_state" "cluster" {
  backend = "local"
  config = {
    path = "../cluster/terraform.tfstate"
  }
}

data "aws_iam_user" "user" {
  for_each  = toset(var.management_users)
  user_name = each.key
}


data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "aws_secretsmanager_secret" "connections" {
  name = data.terraform_remote_state.cluster.outputs.secret_name
}

data "aws_secretsmanager_secret_version" "connections" {
  secret_id = data.aws_secretsmanager_secret.connections.id
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "timescaledb" {
  backend = "local"
  config = {
    path = "../timescaledb/terraform.tfstate"
  }
}