terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  required_version = ">= 1.3.0"
}


# Define resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "${var.labelPrefix}-h09-rg"
  location = var.region
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.labelPrefix}-k8s"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${var.labelPrefix}-k8s"

  default_node_pool {
    name                = "systempool"
    node_count          = 1
    min_count           = 1
    max_count           = 3
    vm_size             = "Standard_B2s"
    enable_auto_scaling = true
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.32.0"
}

