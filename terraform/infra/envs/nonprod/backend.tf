terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stgacinfrasingleappsvc"
    container_name       = "tfstate"
    key                  = "nonprod.terraform.tfstate"
  }
}
