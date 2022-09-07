output "web_name" {
  value = kubernetes_service.web.metadata.0.name
}