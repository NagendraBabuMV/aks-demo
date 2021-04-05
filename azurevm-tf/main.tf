terraform {
  backend "azurerm" {
    resource_group_name   = "rg-tfstate-we01"
    storage_account_name  = "strgtfstatewe01"
    container_name        = "tf-state"
    key                   = "vm.tfstate"
  }
}
provider "azurerm" {
    version = "~>2.0"
    features {}
}

module "azure-vm" {
  source = "../modules/azure-vm"
  resource_group_name = "rg-vm-demo-we01"
  location = "West Europe"
}