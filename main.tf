provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "lab1-resources"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "main" {
  name                = "lab1-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "lab1-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "lab1-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "lab1-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "azureuser@b2"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install nodejs -y",
      "sudo apt-get install npm -y",
      "sudo apt install git -y",
      "git clone https://github.com/prapawit201/INT493-SoftwareArchitec.git",
      "cd INT493-SoftwareArchitec/Lab",
      "npm install",
      "node index.js"
    ]

    connection {
      host     = self.public_ip_address
      user     = "azureuser"
      password = "azureuser@b2"
    }
  }

}
