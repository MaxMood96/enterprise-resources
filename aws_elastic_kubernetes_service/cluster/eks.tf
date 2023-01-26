# Example EKS cluster
# This creates an EKS cluster for the Codecov Enterprise application.
# There are 2 node groups created: web, worker.  The k8s
# deployments are set up to execute on their respective node groups
# using the `role` label.

locals {
  worker_groups = [
    {
      name           = "web"
      min_size       = 1
      desired_size   = var.web_nodes
      max_size       = var.web_nodes * 2
      instance_types = [var.web_node_type]
      labels = {
        "role" = "web"
      }
      iam_role_additional_policies = {}
      vpc_security_group_ids       = [aws_security_group.eks.id]
      launch_template_name         = "web"
      eni_delete                   = "true"
      security_group_additional_rules = {
        ingress_allow_access_from_control_plane = {
          type                          = "ingress"
          protocol                      = "tcp"
          from_port                     = 9443
          to_port                       = 9443
          source_cluster_security_group = true
          description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
        }
      }
    },
    {
      name                         = "worker"
      min_size                     = 1
      desired_size                 = var.worker_nodes
      max_size                     = var.worker_nodes * 2
      instance_types               = [var.worker_node_type]
      iam_role_additional_policies = {}
      vpc_security_group_ids       = [aws_security_group.eks.id]
      launch_template_name         = "worker"
      labels = {
        "role" = "worker"
      }
      security_group_additional_rules = {
        ingress_allow_access_from_control_plane = {
          type                          = "ingress"
          protocol                      = "tcp"
          from_port                     = 9443
          to_port                       = 9443
          source_cluster_security_group = true
          description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
        }
      }
      eni_delete = "true"
    },
  ]
}

resource "aws_security_group" "eks" {
  name_prefix = "codecov-eks"
  vpc_id      = module.vpc.vpc_id
  tags        = merge(var.resource_tags, { Name = "codecov-eks" })
}

resource "aws_security_group_rule" "eks-redis-out" {
  from_port                = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = aws_security_group.elasticache.id
  to_port                  = 6379
  type                     = "egress"
}

resource "aws_security_group_rule" "eks-postgres-out" {
  from_port                = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = aws_security_group.postgres.id
  to_port                  = 5432
  type                     = "egress"
}

resource "aws_security_group_rule" "eks-cluster-in" {
  from_port                = 9443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.cluster_security_group_id
  to_port                  = 9443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-api-in" {
  from_port                = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.cluster_security_group_id
  to_port                  = 8000
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-web-in" {
  from_port                = 5000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.cluster_security_group_id
  to_port                  = 5000
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-api-in" {
  from_port                = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.node_security_group_id
  to_port                  = 8000
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-web-in" {
  from_port                = 5000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.node_security_group_id
  to_port                  = 5000
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-api-out" {
  from_port                = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.cluster_security_group_id
  to_port                  = 8000
  type                     = "egress"
}

resource "aws_security_group_rule" "eks-node-api-out" {
  from_port                = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.node_security_group_id
  to_port                  = 8000
  type                     = "egress"
}

resource "aws_security_group_rule" "eks-web-out" {
  from_port                = 5000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.cluster_security_group_id
  to_port                  = 5000
  type                     = "egress"
}

resource "aws_security_group_rule" "eks-node-web-out" {
  from_port                = 5000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = module.eks.node_security_group_id
  to_port                  = 5000
  type                     = "egress"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18"
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = aws_iam_role.codecov-ebs-csi.arn
    }
  }
  cluster_name                          = var.cluster_name
  subnet_ids                            = module.vpc.private_subnets
  vpc_id                                = module.vpc.vpc_id
  eks_managed_node_groups               = local.worker_groups
  cluster_enabled_log_types             = ["api", "controllerManager", "scheduler"]
  cluster_additional_security_group_ids = [aws_security_group.eks.id]
  create_iam_role                       = true
  tags                                  = var.resource_tags

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

}

resource "aws_iam_role_policy_attachment" "minio" {
  for_each   = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = aws_iam_policy.minio-s3.arn
}