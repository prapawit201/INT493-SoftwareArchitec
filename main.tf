terraform {
  backend "remote" {
    organization = "Software-Architect"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}
provider "azurerm" {
  version = "=2.40.0"
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
