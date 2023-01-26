data "aws_iam_policy_document" "ec2-assume" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}
resource "aws_iam_role" "timescale" {
  name               = "timescale-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume.json
  tags               = data.terraform_remote_state.cluster.outputs.resource_tags
}
resource "aws_iam_role_policy" "s3" {
  name   = "s3"
  role   = aws_iam_role.timescale.id
  policy = data.aws_iam_policy_document.backups.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  depends_on = [aws_iam_role.timescale]
  role       = aws_iam_role.timescale.name
  policy_arn = "arn:${data.terraform_remote_state.cluster.outputs.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm2" {
  depends_on = [aws_iam_role.timescale]
  role       = aws_iam_role.timescale.name
  policy_arn = "arn:${data.terraform_remote_state.cluster.outputs.partition}:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "timescale" {
  name = "timescale_profile"
  role = aws_iam_role.timescale.name
}