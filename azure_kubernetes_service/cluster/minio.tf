resource "random_id" "minio-bucket-suffix" {
  byte_length = "2"
}

resource "azurerm_storage_account" "minio" {
  name                     = "codecov${random_id.minio-bucket-suffix.hex}"
  resource_group_name      = azurerm_resource_group.codecov-enterprise.name
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  location                 = var.location
}