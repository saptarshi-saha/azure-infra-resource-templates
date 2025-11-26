resource "random_password" "mysql_pass" {
  length  = 20
  special = true
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                     = var.mysql_server_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  administrator_login      = var.admin_username
  administrator_password   = random_password.mysql_pass.result
  version                  = var.mysql_version
  sku_name                 = var.sku_name
  delegated_subnet_id      = var.subnet_id
  tags                     = var.tags

  storage {
    size_gb = var.storage_gb
    auto_grow_enabled = true
  }
}



resource "azurerm_key_vault_secret" "mysql_pass" {
  name         = "mysql-admin-password"
  value        = random_password.mysql_pass.result
  key_vault_id = var.keyvault_id
}
