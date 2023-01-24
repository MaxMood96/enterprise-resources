output "eks" {
  value = module.eks
}

output "eks_node_pool_iam_roles" {
  value = [for p in module.eks.eks_managed_node_groups : {
    name = p.iam_role_name
    arn  = p.iam_role_arn
  }]
}

# Include NAT gateway public IP(s) in output if required for firewall rules / access restrictions
output "nat_gateway_ips" {
  value = module.vpc.nat_public_ips
}

output "secret_name" {
  value = aws_secretsmanager_secret.connections.name
}

output "codecov_role_name" {
  value = aws_iam_role.codecov.name
}

output "alb_role_arn" {
  value = var.ingress_enabled ? aws_iam_role.ingress[0].arn : ""
}
output "vpc_security_group_ids" {
  value = aws_security_group.eks.id
}
output "resource_tags" {
  value = var.resource_tags
}
output "vpc_id" {
  value = module.vpc
}
output "vpc_subnets" {
  value = module.vpc.private_subnets_cidr_blocks
}
output "partition" {
  value = local.partition
}
