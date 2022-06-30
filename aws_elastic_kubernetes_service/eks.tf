# Example EKS cluster
# This creates an EKS cluster for the Codecov Enterprise application.
# There are 3 node groups created: web, worker, and minio.  The k8s
# deployments are set up to execute on their respective node groups
# using the `role` label.

locals {
  worker_groups = [
    {
      name                 = "web"
      launch_template_name = "web"
      instance_type        = var.web_node_type
      subnets              = module.vpc.private_subnets
      asg_desired_capacity = var.web_nodes
      kubelet_extra_args   = "--node-labels=kubernetes.io/role=web"
      eni_delete           = "true"
    },
    {
      name                 = "worker"
      launch_template_name = "worker"
      instance_type        = var.worker_node_type
      subnets              = module.vpc.private_subnets
      asg_desired_capacity = var.worker_nodes
      kubelet_extra_args   = "--node-labels=kubernetes.io/role=worker"
      eni_delete           = "true"
    },
  ]
}

module "eks" {
  source                       = "terraform-aws-modules/eks/aws"
  version                      = "~> 18"
  cluster_name                 = var.cluster_name
  subnet_ids                   = module.vpc.private_subnets
  vpc_id                       = module.vpc.vpc_id
  self_managed_node_groups     = local.worker_groups
  cluster_enabled_log_types    = ["api", "controllerManager", "scheduler"]
  iam_role_additional_policies = [aws_iam_policy.minio-s3.id]
  create_iam_role              = true
}

