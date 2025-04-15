terraform {
  required_version = ">= 1.1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.94.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

provider "kubernetes" {
  alias = "test"

  host                   = module.aks_cluster_test.kube_config.host
  client_certificate     = base64decode(module.aks_cluster_test.kube_config.client_certificate)
  client_key             = base64decode(module.aks_cluster_test.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.aks_cluster_test.kube_config.cluster_ca_certificate)
}


provider "kubernetes" {
  alias = "prod"

  host                   = module.aks_cluster_test.kube_config.host
  client_certificate     = base64decode(module.aks_cluster_test.kube_config.client_certificate)
  client_key             = base64decode(module.aks_cluster_test.kube_config.client_key)
  cluster_ca_certificate = base64decode(module.aks_cluster_test.kube_config.cluster_ca_certificate)
}


resource "azurerm_resource_group" "aks_rg" {
  name     = "iac-final-aks-rg"
  location = var.location
}

module "aks_cluster_test" {
  source              = "./modules/aks"
  cluster_name        = "test-aks"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "testaks"
  node_count          = 1
  kubernetes_version  = "1.31.5"
  labelPrefix         = "test"
  region              = "westus3"
}

module "aks_cluster_prod" {
  source              = "./modules/aks"
  cluster_name        = "prod-aks"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "prodaks"
  min_count           = 1
  max_count           = 3
  kubernetes_version  = "1.31.5"
  labelPrefix         = "prod"
  region              = "westus3"
}

module "network" {
  source              = "./modules/network"
  prefix              = "cst8918"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}


module "app_test" {
  source              = "./modules/app"
  name_prefix         = "test"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  region              = var.region
  labelPrefix         = var.labelPrefix

  aks_kubeconfig_raw = module.aks_cluster_test.kube_config
  providers = {
    kubernetes = kubernetes.test
  }
}

module "app_prod" {
  source              = "./modules/app"
  name_prefix         = "prod"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  region              = var.region
  labelPrefix         = var.labelPrefix

  aks_kubeconfig_raw = module.aks_cluster_prod.kube_config

  providers = {
    kubernetes = kubernetes.prod
  }
}