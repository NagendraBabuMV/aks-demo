provider "azurerm" {
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "rsg" {
    name     = var.resource_group_name
    location = var.location

    tags = {
        environment = "Development"
    }
}

resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.rsg.name

    tags = {
        environment = "Development"
    }
}

resource "azurerm_subnet" "subnet" {
    name                 = var.subnet
    resource_group_name  = azurerm_resource_group.rsg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "publicip" {
    name                         = var.public_ip
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rsg.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Development"
    }
}

resource "azurerm_network_security_group" "nsg" {
    name                = var.nsg
    location            = var.location
    resource_group_name = azurerm_resource_group.rsg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Development"
    }
}

resource "azurerm_network_interface" "nic" {
    name                      = var.nic
    location                  = var.location
    resource_group_name       = azurerm_resource_group.rsg.name

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip.id
    }

    tags = {
        environment = "Development"
    }
}

resource "azurerm_network_interface_security_group_association" "nsg-assoiciation" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "azure-vm" {
    name                  = var.azure_vm_name
    location              = var.location
    resource_group_name   = azurerm_resource_group.rsg.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = var.azure_vm_name
    admin_username = var.username
    admin_password = var.password
    disable_password_authentication = false


    tags = {
        environment = "Development"
    }
}