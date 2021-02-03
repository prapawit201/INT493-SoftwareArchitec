provider "azurerm" {
  version = "=2.40.0"
  subscription_id = "6971bfa9-d983-4fad-a11b-14807d6665b5"
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
