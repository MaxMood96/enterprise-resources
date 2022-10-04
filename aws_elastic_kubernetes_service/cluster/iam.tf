
resource "aws_iam_role" "codecov" {
  name_prefix        = "codecov-enterprise-eks-"
  assume_role_policy = data.aws_iam_policy_document.codecov-eks.json
  tags               = var.resource_tags
}

resource "aws_iam_role_policy_attachment" "minio-s3" {
  role       = aws_iam_role.codecov.name
  policy_arn = aws_iam_policy.minio-s3.arn
}

resource "aws_iam_role" "codecov-ebs-csi" {
  name_prefix        = "codecov-ebs-csi-"
  assume_role_policy = data.aws_iam_policy_document.ebs-csi.json
  tags               = var.resource_tags
}

resource "aws_iam_role_policy_attachment" "ebs-csi" {
  role       = aws_iam_role.codecov-ebs-csi.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "ingress" {
  count       = var.ingress_enabled ? 1 : 0
  name_prefix = "codecov-ingress-controller-"
  description = "Permissions required by the Kubernetes ALB Ingress controller"

  tags = var.resource_tags

  assume_role_policy = one(data.aws_iam_policy_document.ingress-oidc.*.json)
}

resource "aws_iam_policy" "ingress" {
  count       = var.ingress_enabled ? 1 : 0
  name_prefix = "codecov-alb-management-"
  description = "Permissions that are required to manage AWS Application Load Balancers."
  policy      = local.govcloud_enabled ? file("files/ingress-govcloud.json") : file("files/ingress.json")
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

resource "random_pet" "user-suffix" {
  length    = "2"
  separator = "-"
}

resource "aws_iam_user" "minio" {
  name = "codecov-minio-${random_pet.user-suffix.id}"
  path = "/system/"
}

resource "aws_iam_user_policy_attachment" "minio" {
  policy_arn = aws_iam_policy.minio-s3.arn
  user       = aws_iam_user.minio.name
}

data "aws_iam_policy_document" "ebs_csi" {
  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
    ]

    resources = ["*"]
  }

  statement {
    actions = ["ec2:CreateTags"]

    resources = [
      "arn:${local.partition}:ec2:*:*:volume/*",
      "arn:${local.partition}:ec2:*:*:snapshot/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values = [
        "CreateVolume",
        "CreateSnapshot",
      ]
    }
  }

  statement {
    actions = ["ec2:DeleteTags"]

    resources = [
      "arn:${local.partition}:ec2:*:*:volume/*",
      "arn:${local.partition}:ec2:*:*:snapshot/*",
    ]
  }

  statement {
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values = [
        true
      ]
    }
  }

  statement {
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values   = ["*"]
    }
  }

  statement {
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

  statement {
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = [true]
    }
  }

  statement {
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values   = ["*"]
    }
  }

  statement {
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

  statement {
    actions   = ["ec2:DeleteSnapshot"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values   = ["*"]
    }
  }

  statement {
    actions   = ["ec2:DeleteSnapshot"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = [true]
    }
  }
}

resource "aws_iam_policy" "ebs_csi" {

  name_prefix = "Codecov_EBS_CSI_Policy-"
  description = "Provides permissions to manage EBS volumes via the container storage interface driver"
  policy      = data.aws_iam_policy_document.ebs_csi.json

  tags = var.resource_tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.codecov-ebs-csi.name
  policy_arn = aws_iam_policy.ebs_csi.arn
}