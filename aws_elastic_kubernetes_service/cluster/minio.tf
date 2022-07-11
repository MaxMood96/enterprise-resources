resource "aws_iam_policy" "minio-s3" {
  name   = "codecov-minio-s3"
  policy = data.aws_iam_policy_document.minio-s3.json
  tags   = var.resource_tags
}

data "aws_iam_policy_document" "minio-s3" {
  statement {
    sid    = "AllowObjectActions"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.minio.arn}/*"
    ]
  }

  statement {
    sid    = "AllowListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"

    ]
    resources = [
      aws_s3_bucket.minio.arn
    ]
  }

  statement {
    sid    = "AllowAllS3"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation"
    ]
    resources = [
      "*"
    ]
  }
}

resource "random_pet" "minio-bucket-suffix" {
  length    = "2"
  separator = "-"
}

resource "aws_s3_bucket" "minio" {
  bucket = "codecov-minio-${random_pet.minio-bucket-suffix.id}"

  tags = var.resource_tags
}

resource "aws_s3_bucket_acl" "minio" {
  bucket = aws_s3_bucket.minio.id
  acl    = "private"
}
