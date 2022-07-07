
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "aws_secretsmanager_secret" "connections" {
  name = "codecov-connections"
}

data "aws_secretsmanager_secret_version" "connections" {
  secret_id = data.aws_secretsmanager_secret.connections.id
}

data "aws_caller_identity" "current" {}
