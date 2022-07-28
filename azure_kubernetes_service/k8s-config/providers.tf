provider "azurerm" {
  features {}
}

provider "kubernetes" {

  host = data.terraform_remote_state.cluster.outputs.kubeconfig_host
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.kubeconfig_cluster_ca_certificate,
  )
  client_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.kubeconfig_client_certificate,
  )
  client_key = base64decode(
    data.terraform_remote_state.cluster.outputs.kubeconfig_client_key,
  )
}
