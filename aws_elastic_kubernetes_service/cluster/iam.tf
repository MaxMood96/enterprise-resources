data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "codecov-eks" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.codecov_namespace}:codecov"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "ingress-oidc" {
  count = var.ingress_enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values = [
        "system:serviceaccount:${var.ingress_namespace}:alb-ingress-controller"
      ]
    }
    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "codecov" {
  name               = "codecov-enterprise-eks"
  assume_role_policy = data.aws_iam_policy_document.codecov-eks.json
  tags               = var.resource_tags
}

resource "aws_iam_role_policy_attachment" "minio-s3" {
  role       = aws_iam_role.codecov.name
  policy_arn = aws_iam_policy.minio-s3.arn
}

resource "aws_iam_role" "ingress" {
  count       = var.ingress_enabled ? 1 : 0
  name        = "codecov-ingress-controller"
  description = "Permissions required by the Kubernetes ALB Ingress controller"

  tags = var.resource_tags

  assume_role_policy = one(data.aws_iam_policy_document.ingress-oidc.*.json)
}

resource "aws_iam_policy" "ingress" {
  count       = var.ingress_enabled ? 1 : 0
  name        = "codecov-alb-management"
  description = "Permissions that are required to manage AWS Application Load Balancers."
  policy      = file("files/ingress.json")
  tags        = var.resource_tags
}

resource "aws_iam_role_policy_attachment" "ingress" {
  count      = var.ingress_enabled ? 1 : 0
  policy_arn = one(aws_iam_policy.ingress.*.arn)
  role       = one(aws_iam_role.ingress.*.name)
}

resource "aws_iam_access_key" "minio" {
  user = aws_iam_user.minio.name
}

resource "aws_iam_user" "minio" {
  name = "codecov-minio"
  path = "/system/"
}

resource "aws_iam_user_policy_attachment" "minio" {
  policy_arn = aws_iam_policy.minio-s3.arn
  user       = aws_iam_user.minio.name
}