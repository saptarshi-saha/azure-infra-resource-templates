output "app_insights_id" {
  value = azurerm_application_insights.app_insights.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics.id
}
output "app_insights_name" {
  value = azurerm_application_insights.app_insights.name
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log_analytics.name
}
