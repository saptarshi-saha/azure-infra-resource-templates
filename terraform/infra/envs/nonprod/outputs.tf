output "app_service_url" {
  value = module.appservice.app_default_hostname
}

output "mysql_fqdn" {
  value = module.mysql.mysql_fqdn
}

output "keyvault_uri" {
  value = module.keyvault.keyvault_uri
}
