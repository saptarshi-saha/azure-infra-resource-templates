environment       = "nonprod"
project_name      = "snipeit"
location          = "eastus"

vnet_cidr        = "10.20.0.0/16"
subnet_app_cidr  = "10.20.1.0/24"
subnet_db_cidr   = "10.20.2.0/24"

mysql_admin_user = "snipeuser"
mysql_sku_name   = "B_Standard_B1ms"
mysql_storage_gb = 32
mysql_version    = "8.0.21"

app_sku_name = "P0v3"

default_tags = {
  environment = "nonprod"
  owner       = "platform-team"
  project     = "snipeit"
}
project_domain = "mycompany.com"
