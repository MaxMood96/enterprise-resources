locals {
  timescale_url = var.timescale_server_replication_enabled ? "postgres://codecov:${random_password.timescale.result}@${aws_instance.primary_ec2[0].private_ip}:5432" : "postgres://codecov:${random_password.timescale.result}@${aws_instance.vm_ec2[0].private_ip}:5432"
  cidr_blocks = concat([var.subnet_ip], data.terraform_remote_state.cluster.outputs.vpc_subnets)
}