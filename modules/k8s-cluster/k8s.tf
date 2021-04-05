# create the resource group
resource "azurerm_resource_group" "rsg" {
    name     = var.resource_group_name
    location = var.location
}

# AKS cluster resource creation
resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.rsg.location
    resource_group_name = azurerm_resource_group.rsg.name
    dns_prefix          = var.dns_prefix

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = var.vm_size
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    network_profile {
        load_balancer_sku = var.load_balancer_sku
        network_plugin = var.network_plugin
    }

    tags = {
        Environment = "Development"
    }
}