variable "resource_group_name" {}
variable "vnet_name" {}
variable "location" {}
variable "app_subnet_cidr" {}
variable "db_subnet_cidr" {}
variable "tags" {
  type = map(string)
}
