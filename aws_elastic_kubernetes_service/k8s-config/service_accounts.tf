
resource "kubernetes_service_account" "codecov" {
  metadata {
    name      = "codecov"
    namespace = var.codecov_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/codecov-enterprise-eks"
    }
  }
}
