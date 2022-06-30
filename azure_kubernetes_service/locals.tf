locals {
  postgres_username = "${azurerm_postgresql_server.codecov.administrator_login}@${azurerm_postgresql_server.codecov.name}"
  postgres_url      = "postgres://${azurerm_postgresql_server.codecov.administrator_login}:${azurerm_postgresql_server.codecov.administrator_login_password}@${local.postgres_host}/codecov"
  postgres_password = azurerm_postgresql_server.codecov.administrator_login_password
  postgres_host     = "${azurerm_postgresql_server.codecov.fqdn}:5432"
  redis_url         = "redis://${azurerm_redis_cache.codecov.hostname}:${azurerm_redis_cache.codecov.port}"
}

