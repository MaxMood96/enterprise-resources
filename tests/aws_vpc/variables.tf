variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "postgres_instance_class" {
  description = "Instance class for PostgreSQL RDS instance"
  default     = "db.t3.micro"
}

variable "postgres_skip_final_snapshot" {
  description = "Whether to skip taking a final snapshot when destroying the Postgres DB"
  default     = "0"
}
