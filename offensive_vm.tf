#Variable Processing
# Setup the userdata that will be used for the instance
data "template_file" "userdata_setup" {
  template = "${file("userdata_setup.template")}"

  vars  = {
    name       = "${var.username}"
    password   = "${var.password}"
    logic = "${file("offensive_bootstrap.sh")}"
  }
}

# Create Security Group to access web

resource "azurerm_network_security_group" "offensive-linux-nsg" {
  depends_on=[azurerm_resource_group.offensive-network-rg]
  name = "offensive-web-linux-vm-nsg"
  location            = azurerm_resource_group.offensive-network-rg.location
  resource_group_name = azurerm_resource_group.offensive-network-rg.name
  security_rule {
    name                       = "allow-ssh"
    description                = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

#Public IP Address

resource "azurerm_public_ip" "offensivepublicip" {
    name                         = "${var.company}-public-ip"
    location                     = azurerm_resource_group.offensive-network-rg.location
    resource_group_name          = azurerm_resource_group.offensive-network-rg.name
    allocation_method = "Static"
}

# Output the public ip of the gateway

output "Attacker_IP" {
    value = azurerm_public_ip.offensivepublicip.ip_address
}


#Create Network Interface
resource "azurerm_network_interface" "offensive-ubuntu" {
  name                = "${var.company}-nic"
  location            = azurerm_resource_group.offensive-network-rg.location
  resource_group_name = azurerm_resource_group.offensive-network-rg.name

  ip_configuration {
    name                          = "${var.company}-ip"
    subnet_id                     = azurerm_subnet.offensive-network-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = var.internal-private-ip
    primary = true
        public_ip_address_id = azurerm_public_ip.offensivepublicip.id
  }
}

#Associate Security Group with Internface

resource "azurerm_network_interface_security_group_association" "offensive-linux-nsg-int" {
  network_interface_id      = azurerm_network_interface.offensive-ubuntu.id
  network_security_group_id = azurerm_network_security_group.offensive-linux-nsg.id
  }


resource "azurerm_virtual_machine" "main" {
  name                  = "${var.company}-attacker"
  location              = azurerm_resource_group.offensive-network-rg.location
  resource_group_name   = azurerm_resource_group.offensive-network-rg.name
  network_interface_ids = [azurerm_network_interface.offensive-ubuntu.id]
  depends_on = [
    azurerm_network_interface_security_group_association.offensive-linux-nsg-int
  ]
  
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.company}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.company}-attacker"
    admin_username = var.username
    admin_password = var.password
    custom_data = data.template_file.userdata_setup.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}

