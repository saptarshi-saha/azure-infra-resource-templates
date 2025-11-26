resource "azurerm_application_insights" "app_insights" {
  name                = "${var.app_service_name}-ai"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.app_service_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "app_diag" {
  name               = "${var.app_service_name}-diag"
  target_resource_id = var.app_service_id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

  log_settings {
    category = "AppServiceConsoleLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric_settings {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}


