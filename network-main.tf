# Create a resource group for offensive vm
resource "azurerm_resource_group" "offensive-network-rg" {
  name     = "${var.company}-rg"
  location = var.location
}

# Create the victim network VNET
resource "azurerm_virtual_network" "offensive-network-vnet" {
  name                = "${var.company}-vnet"
  address_space       = [var.offensive-network-vnet-cidr]
  resource_group_name = azurerm_resource_group.offensive-network-rg.name
  location            = azurerm_resource_group.offensive-network-rg.location
}

# Create a victim subnet for Network
resource "azurerm_subnet" "offensive-network-subnet" {
  name                 = "${var.company}-subnet"
  address_prefix       = var.offensive-network-subnet-cidr
  virtual_network_name = azurerm_virtual_network.offensive-network-vnet.name
  resource_group_name  = azurerm_resource_group.offensive-network-rg.name
}
