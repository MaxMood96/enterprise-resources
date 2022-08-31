resource "kubernetes_storage_class" "ebs" {
  storage_provisioner = "ebs.csi.aws.com"
  metadata {
    name = "ebs-sc"
  }
  volume_binding_mode = "Immediate"
}