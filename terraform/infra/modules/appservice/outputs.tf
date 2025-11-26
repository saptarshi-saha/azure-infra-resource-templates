output "app_id" { 
    value = azurerm_app_service.app.id 
}
output "app_default_hostname" {
  value = azurerm_app_service.app.default_site_hostname
}

output "app_name" {
  value = azurerm_app_service.app.name
}
output "app_service_id" {
  value       = azurerm_app_service.app.id
  description = "The ID of the App Service"
}

output "default_site_hostname" {
  value       = azurerm_app_service.app.default_site_hostname
  description = "The default hostname of the App Service"
}

