
provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "6971bfa9-d983-4fad-a11b-14807d6665b5"
  client_id       = "65c4e446-fbe8-43bf-93c7-e60afa777449"
  client_secret   = "WQZSkFYvXjdkSZIAaAAa9_n2yo6giQQxAH"
  tenant_id       = "79845616-9df0-43e0-8842-e300feb2642a"
  
  features {}
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "lab1-test"
  resource_group_name             = "group-project"
  location                        = "Southeast Asia"
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "azureuser@b2"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
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
      "cd ..",
      "sudo mv myapp.service /lib/systemd/system/myapp.service",
      "sudo systemctl enable myapp.service",
      "sudo systemctl start myapp.service",
    ]

    connection {
      host     = self.public_ip_address
      user     = self.admin_username
      password = self.admin_password
    }
  }
}
