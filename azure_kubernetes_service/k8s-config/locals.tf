locals {
  postgres_username = "${data.terraform_remote_state.cluster.outputs.postgres_username}@${data.terraform_remote_state.cluster.outputs.postgres_server_name}"
  postgres_url      = "postgres://${local.postgres_username}:${local.postgres_password}@${local.postgres_host}/codecov"
  postgres_password = data.terraform_remote_state.cluster.outputs.postgres_pw
  postgres_host     = "${data.terraform_remote_state.cluster.outputs.postgres_fqdn}:5432"
  redis_url         = "redis://${data.terraform_remote_state.cluster.outputs.redis_hostname}:${data.terraform_remote_state.cluster.outputs.redis_port}"
}


/*
locals {
  postgres_username = "${azurerm_postgresql_server.codecov.administrator_login}@${azurerm_postgresql_server.codecov.name}"
  postgres_url      = "postgres://${azurerm_postgresql_server.codecov.administrator_login}:${azurerm_postgresql_server.codecov.administrator_login_password}@${local.postgres_host}/codecov"
  postgres_password = azurerm_postgresql_server.codecov.administrator_login_password
  postgres_host     = "${azurerm_postgresql_server.codecov.fqdn}:5432"
  redis_url         = "redis://${azurerm_redis_cache.codecov.hostname}:${azurerm_redis_cache.codecov.port}"
}*/