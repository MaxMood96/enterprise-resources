resource "kubernetes_service_account" "traefik" {
  metadata {
    name      = "codecov-traefik"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role" "traefik" {
  metadata {
    name = "codecov-traefik"
  }

  rule {
    api_groups = [""]
    resources = [
      "services",
      "endpoints",
      "secrets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "extensions",
    ]
    resources = [
      "ingresses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "traefik" {
  metadata {
    name = "codecov-traefik"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.traefik.metadata[0].name
    namespace = kubernetes_service_account.traefik.metadata[0].namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.traefik.metadata[0].name
  }
}

