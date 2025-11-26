resource "azurerm_service_plan" "plan" {
  name                = var.plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name = var.sku_name
  tags = var.tags
}

resource "azurerm_app_service" "app" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    DATABASE_FQDN     = var.mysql_fqdn
    DATABASE_USER     = var.mysql_user
    DATABASE_PASSWORD = "@Microsoft.KeyVault(SecretUri=${var.mysql_password_secret_uri})"
  }

  tags = var.tags
}

