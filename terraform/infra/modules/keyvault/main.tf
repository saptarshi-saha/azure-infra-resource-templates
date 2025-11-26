resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                     = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled     = false
  tags                        = var.tags
}

data "azurerm_client_config" "current" {}

