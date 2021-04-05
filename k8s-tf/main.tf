terraform {
  backend "azurerm" {
    resource_group_name   = "rg-tfstate-we01"
    storage_account_name  = "strgtfstatewe01"
    container_name        = "tf-state"
    key                   = "aks.tfstate"
  }
}
provider "azurerm" {
    version = "~>2.0"
    features {}
}

module "aks_cluster" {
  source = "../modules/k8s-cluster"
  cluster_name = "aks-demo-we01"
  resource_group_name = "rg-aks-demo-we01"
  location = "West Europe"
  client_id = "c31f2ed4-8985-46f9-844c-8f1a93351d73"
  client_secret = "VEWEC99UX.7D1bizP.h8jwe~GE~L.qCYJR"
  agent_count = 1
  dns_prefix = "aks-demo"
  vm_size = "Standard_D2_v3"
  load_balancer_sku = "Standard"
  network_plugin = "kubenet"
}