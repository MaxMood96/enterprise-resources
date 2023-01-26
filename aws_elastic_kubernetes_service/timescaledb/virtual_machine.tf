resource "aws_instance" "vm_ec2" {
  depends_on                  = [aws_eip.ec2]
  count                       = var.timescale_server_replication_enabled == false ? 1 : 0
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = data.aws_availability_zones.list.names[0]
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.timescale.name
  associate_public_ip_address = true
  key_name                    = aws_key_pair.timescale_db_key.key_name
  subnet_id                   = aws_subnet.ec2_subnet.id


  vpc_security_group_ids = [data.terraform_remote_state.cluster.outputs.vpc_security_group_ids]
  user_data = templatefile("../../modules/timescale_db/files/timescale_single_server.sh", {
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
  Name = "timescaledb" }
}