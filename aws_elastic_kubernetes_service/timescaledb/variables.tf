variable "timescale_server_replication_enabled" {
  default     = true
  description = "enabling creates 2 servers with primary/secondary replication"
}

variable "instance_type" {
  default = "t3.micro"
}
variable "subnet_ip" {
  default = "10.0.27.0/24"
}
variable "prepend_userdata" {
  description = "allows you to add to scripts"
  default     = ""
}
variable "public_key" {
  description = "input local ssh key"
}
variable "vpc_private_name" {
  default     = "codecov-vpc-private"
  description = "private name for vpc"
}
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}