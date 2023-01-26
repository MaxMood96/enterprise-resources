resource "random_pet" "name" {
}
resource "aws_s3_bucket" "backups" {
  bucket = "codecov-${random_pet.name.id}"

  tags = data.terraform_remote_state.cluster.outputs.resource_tags

}

resource "aws_s3_bucket_acl" "timescale_backups_acl" {
  bucket = aws_s3_bucket.backups.id
  acl    = "private"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


