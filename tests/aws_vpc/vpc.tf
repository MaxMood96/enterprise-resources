# Example VPC
# This creates a VPC for the Codecov Enterprise deployment and associated
# resources.

data "aws_availability_zones" "list" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "codecov-vpc"
  cidr   = "10.0.16.0/20"
  azs = [
    "${data.aws_availability_zones.list.names[0]}",
    "${data.aws_availability_zones.list.names[1]}",
    "${data.aws_availability_zones.list.names[2]}"
  ]
  public_subnets = [
    "10.0.16.0/24",
    "10.0.17.0/24",
    "10.0.18.0/24"
  ]
  private_subnets = [
    "10.0.24.0/24",
    "10.0.25.0/24",
    "10.0.26.0/24"
  ]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    "kubernetes.io/cluster/default-codecov-cluster" = "shared"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_private_subnet_ids" {
  value = ["${module.vpc.private_subnets}"]
}

output "postgres_url" {
  value = "postgres://${aws_db_instance.postgres.username}:${random_string.postgres-password.result}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.name}"
}

output "s3_bucket" {
  value = aws_s3_bucket.minio.id
}
