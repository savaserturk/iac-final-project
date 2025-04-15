terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}


resource "random_string" "acr_suffix" {
  length  = 4
  special = false
  upper   = false
}

# ACR
resource "azurerm_container_registry" "acr" {
  name                = "${var.name_prefix}acr${random_string.acr_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Redis
resource "azurerm_redis_cache" "redis" {
  name                 = "${var.name_prefix}redis-savas"
  location             = var.location
  resource_group_name  = var.resource_group_name
  capacity             = 1
  family               = "C"
  sku_name             = "Basic"
  non_ssl_port_enabled = true
}

resource "kubernetes_deployment" "remix_app" {
  metadata {
    name      = "${var.name_prefix}-remix"
    namespace = "default"
    labels = {
      app = "remix"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "remix"
      }
    }

    template {
      metadata {
        labels = {
          app = "remix"
        }
      }

      spec {
        container {
          image = "${azurerm_container_registry.acr.login_server}/remix-weather:latest"
          name  = "remix"

          port {
            container_port = 3000
          }

          env {
            name  = "WEATHER_API_KEY"
            value = "98a356b16aa0a1881aca3a035bb570b6"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "remix_service" {
  metadata {
    name = "${var.name_prefix}-remix-service"
  }

  spec {
    selector = {
      app = "remix"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 3000
    }
  }
}

resource "random_string" "redis_suffix" {
  length  = 4
  special = false
  upper   = false
}