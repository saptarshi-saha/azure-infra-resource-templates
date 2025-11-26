variable "environment" {}
variable "project_name" {}
variable "location" {}

variable "vnet_cidr" {}
variable "subnet_app_cidr" {}
variable "subnet_db_cidr" {}

variable "mysql_admin_user" {}
variable "mysql_sku_name" {}
variable "mysql_storage_gb" {}
variable "mysql_version" {}

variable "app_sku_name" {}

variable "default_tags" {
  type = map(string)
}
variable "project_domain" {
  type        = string
  description = "Domain for your project frontend host"
  default     = "example.com"   # set your actual domain here
}
