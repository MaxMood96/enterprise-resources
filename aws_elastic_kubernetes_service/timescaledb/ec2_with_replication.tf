resource "random_password" "timescale" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_eip" "ec2" {
  count = var.timescale_server_replication_enabled ? 2 : 1
  vpc   = true
  tags  = {}
}

resource "aws_instance" "primary_ec2" {
  depends_on                  = [aws_eip.ec2]
  count                       = var.timescale_server_replication_enabled ? 1 : 0
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  iam_instance_profile        = one(aws_iam_instance_profile.timescale.*.name)
  associate_public_ip_address = true
  key_name                    = aws_key_pair.timescale_db_key.key_name
  subnet_id                   = aws_subnet.ec2_subnet.id


  vpc_security_group_ids = [data.terraform_remote_state.cluster.outputs.vpc_security_group_ids]
  user_data = templatefile("../../modules/timescale_db/files/timescale_replication_server_primary.sh", {
    MasterIP           = aws_eip.ec2[0].address
    timescale_password = random_password.timescale.result
    stanza_name        = "db-primary"
    bucket             = aws_s3_bucket.backups.bucket
    IP_RANGE           = var.subnet_ip
    prepend_userdata   = var.prepend_userdata
    backups = templatefile("../../modules/timescale_db/files/pgbackrest.sh", {
      stanza_name = "db-primary"
      bucket      = aws_s3_bucket.backups.bucket
      region      = aws_s3_bucket.backups.region
      endpoint    = "s3.${aws_s3_bucket.backups.region}.amazonaws.com"
      gcp         = false
    })
  })

  tags = {
  Name = "timescaledb-primary" }
}
resource "aws_instance" "secondary_ec2" {
  depends_on                  = [aws_eip.ec2]
  count                       = var.timescale_server_replication_enabled ? 1 : 0
  ami                         = data.aws_ami.ubuntu.id #"SupportedImages ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220421-0bfd8576-6b8c-416e-9afe-c85f76b0bb8f"
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  iam_instance_profile        = one(aws_iam_instance_profile.timescale.*.name)
  associate_public_ip_address = true
  key_name                    = aws_key_pair.timescale_db_key.key_name
  subnet_id                   = aws_subnet.ec2_subnet.id


  vpc_security_group_ids = [data.terraform_remote_state.cluster.outputs.vpc_security_group_ids]
  user_data = templatefile("../../modules/timescale_db/files/timescale_replication_server_secondary.sh", {
    MasterIP           = aws_instance.primary_ec2[count.index].private_ip
    prepend_userdata   = var.prepend_userdata
    timescale_password = random_password.timescale.result
    IP_RANGE           = aws_subnet.ec2_subnet.id
    gcp                = false
  })


  tags = {
  Name = "timescaledb-secondary" }
}

resource "aws_security_group" "timescale" {
  count       = var.timescale_server_replication_enabled ? 1 : 0
  description = "Controls access to the timescaledb"
  vpc_id      = data.terraform_remote_state.cluster.outputs.vpc_id["vpc_id"]
  name        = "timescaledb-sg"
  tags        = data.terraform_remote_state.cluster.outputs.resource_tags
}

resource "aws_security_group_rule" "timescale-egress" {
  count             = var.timescale_server_replication_enabled ? 1 : 0
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.terraform_remote_state.cluster.outputs.vpc_security_group_ids
}

resource "aws_security_group_rule" "timescaledb-ingress-ssh" {
  for_each          = toset(data.terraform_remote_state.cluster.outputs.vpc_subnets)
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  description       = each.key
  cidr_blocks       = [each.value]
  security_group_id = data.terraform_remote_state.cluster.outputs.vpc_security_group_ids
}
