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
