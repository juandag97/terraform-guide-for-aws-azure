# -----------------------------------------------
# Workshop Terraform - Azure Container App
# -----------------------------------------------
# Despliega una app Node.js/Express en Container Apps
# Puerto: 8080 | Ingress: externo (HTTPS público)
# -----------------------------------------------

terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# -----------------------------------------------
# Resource Group
# -----------------------------------------------

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# -----------------------------------------------
# Log Analytics Workspace
# (requerido por Container App Environment)
# -----------------------------------------------

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# -----------------------------------------------
# Container App Environment
# Entorno compartido donde viven los contenedores
# -----------------------------------------------

resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.project_name}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

# -----------------------------------------------
# Container App
# La app Node.js/Express en el puerto 8080
# -----------------------------------------------

resource "azurerm_container_app" "main" {
  name                         = "ca-${var.project_name}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  # Ingress externo - expone la app públicamente vía HTTPS
  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    # Réplicas: 0 mín = escala a cero (ahorra costos)
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "app"
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory

      # Variable de entorno disponible dentro del contenedor
      env {
        name  = "PORT"
        value = "8080"
      }

      env {
        name  = "ENVIRONMENT"
        value = "azure"
      }
    }
  }
}
