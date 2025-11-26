provider "azurerm" {
  features {}
}

provider "random" {}

module "network" {
  source              = "../../modules/network"
  resource_group_name = "${var.project_name}-${var.environment}-rg"
  vnet_name           = "${var.project_name}-${var.environment}-vnet"
  location            = var.location
  app_subnet_cidr     = var.subnet_app_cidr
  db_subnet_cidr      = var.subnet_db_cidr
  tags                = var.default_tags
}

module "keyvault" {
  source       = "../../modules/keyvault"
  kv_name      = "${var.project_name}-${var.environment}-kv"
  location     = var.location
  resource_group_name = "${var.project_name}-${var.environment}-rg"
  tags         = var.default_tags
}

module "mysql" {
  source            = "../../modules/mysql"
  mysql_server_name = "${var.project_name}-${var.environment}-mysql"
  resource_group_name = "${var.project_name}-${var.environment}-rg"
  location          = var.location
  admin_username    = var.mysql_admin_user
  sku_name          = var.mysql_sku_name
  storage_gb        = var.mysql_storage_gb
  mysql_version           = var.mysql_version
  subnet_id         = module.network.db_subnet_id
  keyvault_id       = module.keyvault.keyvault_id
}

module "appservice" {
  source                   = "../../modules/appservice"
  app_name                 = "${var.project_name}-${var.environment}-app"
  plan_name                = "${var.project_name}-${var.environment}-plan"
  resource_group_name      = "${var.project_name}-${var.environment}-rg"
  sku_name             = var.app_sku_name
  app_subnet_id            = module.network.app_subnet_id
  mysql_fqdn               = module.mysql.mysql_fqdn
  mysql_user               = module.mysql.mysql_username
  mysql_password_secret_uri = module.mysql.mysql_password_secret_uri
  keyvault_id              = module.keyvault.keyvault_id
  location                 = var.location
  tags                     = var.default_tags
}


# module "monitoring" {
#   source = "../../modules/monitoring"
#   resource_group_name = "${var.project_name}-${var.environment}-rg"
#   app_service_name           = module.appservice.app_name
#   app_service_id             = module.appservice.app_service_id          # Resource ID output from appservice module
#   #log_analytics_workspace_id = module.log_analytics_workspace.workspace_id # Resource ID of Log Analytics workspace
#   location            = var.location
#   tags                = var.default_tags
# }

module "frontdoor_waf" {
  source                 = "../../modules/frontdoor_waf"
  frontdoor_name         = "${var.project_name}-${var.environment}-fd"
  frontend_host          = "nonprod.${var.project_domain}"
  frontend_endpoint_name = "${var.project_name}-${var.environment}-endpoint"
  backend_host           = module.appservice.default_site_hostname
  waf_name               = "${var.project_name}${var.environment}waf"
  resource_group_name    = "${var.project_name}-${var.environment}-rg"
  location               = var.location
  tags                   = var.default_tags
}
