output "vnet_id" { 
    value = azurerm_virtual_network.vnet.id 
}
output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id  
}

output "rg_name" {
  value = var.resource_group_name
}
