provider "azurerm" {

  version         = "=2.4.0"
  subscription_id = "6971bfa9-d983-4fad-a11b-14807d6665b5"
  client_id       = "65c4e446-fbe8-43bf-93c7-e60afa777449"
  client_secret   = "WQZSkFYvXjdkSZIAaAAa9_n2yo6giQQxAH"
  tenant_id       = "79845616-9df0-43e0-8842-e300feb2642a"
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "lab2-test"
  location = "Southeast Asia"
}

resource "azurerm_virtual_network" "main" {
  name                = "lab2-test-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "main" {
  name                = "lab2-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "lab2-nic"
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
  name                            = "lab2-vm"
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
    sku       = "18.04-LTS"
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
      "sudo npm install -g pm2",
      "pm2 start index.js"
    ]

    connection {
      host     = self.public_ip_address
      user     = "azureuser"
      password = "azureuser@b2"
    }
  }
}
