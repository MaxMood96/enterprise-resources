resource "aws_security_group_rule" "timescale_rule" {
  from_port         = 5432
  protocol          = "TCP"
  security_group_id = data.terraform_remote_state.cluster.outputs.vpc_security_group_ids
  to_port           = 5432
  type              = "ingress"
  cidr_blocks       = [var.subnet_ip]
}