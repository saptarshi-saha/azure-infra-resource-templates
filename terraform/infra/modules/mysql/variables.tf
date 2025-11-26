variable "mysql_server_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "admin_username" {}
variable "sku_name" {}
variable "mysql_version" {
  type        = string
  description = "MySQL version for flexible server"
}

variable "subnet_id" {}
variable "keyvault_id" {}
variable "storage_gb" { type = number }
variable "tags"       { 
    type = map(string) 
    default = {}
}

