resource "aws_db_subnet_group" "postgres" {
  name       = "codecov-postgres"
  subnet_ids = ["${module.vpc.private_subnets}"]
}

resource "aws_security_group" "postgres" {
  name_prefix = "codecov-postgres"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "${module.vpc.vpc_cidr_block}",
    ]
  }
}

resource "random_string" "postgres-password" {
  length  = "16"
  special = "false"
}

resource "random_string" "identifier-suffix" {
  length  = "3"
  special = "false"
  upper   = "false"
}

resource "aws_db_instance" "postgres" {
  identifier                = "codecov-postgres-${random_string.identifier-suffix.result}"
  engine                    = "postgres"
  engine_version            = "10.6"
  allocated_storage         = "20"
  storage_type              = "gp2"
  instance_class            = var.postgres_instance_class
  db_subnet_group_name      = aws_db_subnet_group.postgres.name
  name                      = "codecov"
  username                  = "codecov"
  password                  = random_string.postgres-password.result
  vpc_security_group_ids    = ["${aws_security_group.postgres.id}"]
  skip_final_snapshot       = var.postgres_skip_final_snapshot
  final_snapshot_identifier = "codecov-postgres-${random_string.identifier-suffix.result}-final"
}

resource "random_pet" "minio-bucket-suffix" {
  length    = "2"
  separator = "-"
}

resource "aws_s3_bucket" "minio" {
  bucket = "codecov-minio-${random_pet.minio-bucket-suffix.id}"
  acl    = "private"
}

output "postgres-username" {
  value = aws_db_instance.postgres.username
}

output "postgres-password" {
  value = random_string.postgres-password.result
}
