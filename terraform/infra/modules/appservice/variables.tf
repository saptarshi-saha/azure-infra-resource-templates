variable "app_name" {}
variable "plan_name" {}
variable "resource_group_name" {}
variable "app_subnet_id" {}
variable "mysql_fqdn" {}
variable "mysql_user" {}
variable "mysql_password_secret_uri" {}
variable "keyvault_id" {}
variable "tags" {
  type = map(string)
}
variable "location" {
  type = string
  description = "Azure region for App Service Plan and App Service"
}
variable "sku_name" {
  description = "Azure SKU name such as B1, S1, P1v3, Y1"
}
