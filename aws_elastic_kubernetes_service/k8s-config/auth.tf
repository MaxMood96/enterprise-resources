locals {
  aws_auth_users = [for u in var.management_users : {
    userarn  = data.aws_iam_user.user[u].arn
    username = u
    groups   = ["system:masters"]
  }]
  aws_auth_configmap_data = {
    mapRoles = yamlencode(concat(
      [for role in data.terraform_remote_state.cluster.outputs.eks_node_pool_iam_roles : {
        rolearn  = role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
        }
      ]
    ))
    mapUsers = yamlencode(local.aws_auth_users)
  }
}


resource "kubernetes_config_map_v1_data" "aws_auth" {
  count = length(var.management_users) > 0 ? 1 : 0

  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data
}
