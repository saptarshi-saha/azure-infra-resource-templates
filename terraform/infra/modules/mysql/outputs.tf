output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "mysql_username" {
  value = var.admin_username
}

output "mysql_password_secret_uri" {
  value = azurerm_key_vault_secret.mysql_pass.id
}
