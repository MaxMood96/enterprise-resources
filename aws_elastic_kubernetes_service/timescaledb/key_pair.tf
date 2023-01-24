resource "aws_key_pair" "timescale_db_key" {
  key_name   = "timescale-key"
  public_key = var.public_key
}