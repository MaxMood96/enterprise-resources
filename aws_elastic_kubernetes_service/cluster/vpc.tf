# Example VPC
# This creates a VPC for the Codecov Enterprise deployment and associated
# resources.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"
  name    = var.vpc_name
  cidr    = "10.0.16.0/20"
  azs = [
    data.aws_availability_zones.list.names[0],
    data.aws_availability_zones.list.names[1],
    data.aws_availability_zones.list.names[2],
  ]
  public_subnets = [
    "10.0.16.0/24",
    "10.0.17.0/24",
    "10.0.18.0/24",
  ]
  private_subnets = [
    "10.0.24.0/24",
    "10.0.25.0/24",
    "10.0.26.0/24",
  ]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = merge({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    },
    var.resource_tags
  )
  public_subnet_tags = merge({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
    },
    var.resource_tags
  )
  private_subnet_tags = merge({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
    },
    var.resource_tags
  )
}