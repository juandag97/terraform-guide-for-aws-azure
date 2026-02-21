# ============================================================
# Workshop Terraform — Azure
# Deploy: App Service Plan + App Service (Node.js 20 LTS)
# ============================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# El provider de Azure requiere este bloque de features (puede ir vacío)
provider "azurerm" {
  features {}
}

# ------------------------------------------------------------
# DATOS LOCALES
# Valores calculados que usamos en múltiples recursos
# ------------------------------------------------------------
locals {
  # Los nombres en Azure deben ser únicos globalmente para App Service
  # Usamos un sufijo random para evitar colisiones
  prefix   = "${var.project_name}-${var.environment}"
  app_name = "${local.prefix}-app-${var.random_suffix}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------
# RESOURCE GROUP
# En Azure, todos los recursos deben estar dentro de un Resource Group
# Es el contenedor lógico principal
# ------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-rg"
  location = var.location

  tags = local.common_tags
}

# ------------------------------------------------------------
# APP SERVICE PLAN
# Define el "hardware" subyacente: CPU, memoria, escalado
# Es como elegir el tipo de servidor
# ------------------------------------------------------------
resource "azurerm_service_plan" "main" {
  name                = "${local.prefix}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  os_type  = "Linux"   # Necesario para Node.js en App Service
  sku_name = var.sku_name

  tags = local.common_tags
}

# ------------------------------------------------------------
# APP SERVICE (Linux)
# El servicio web en sí — corre nuestra app Node.js
# ------------------------------------------------------------
resource "azurerm_linux_web_app" "main" {
  name                = local.app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  # Configuración del sitio
  site_config {
    # Stack de la aplicación: runtime y versión
    application_stack {
      node_version = var.node_version
    }

    # Siempre activo: evita que la app "duerma" por inactividad
    # Requiere plan B1 o superior
    always_on = true

    # Comando de inicio personalizado
    # Si tu package.json tiene "start": "node index.js", esto no es necesario
    # app_command_line = "node index.js"
  }

  # Variables de entorno disponibles en la app (process.env.XXX)
  app_settings = {
    ENVIRONMENT  = var.environment
    PROJECT_NAME = var.project_name
    NODE_ENV     = var.environment == "prod" ? "production" : "development"

    # Azure espera que la app escuche en este puerto
    WEBSITES_PORT = "8080"
  }

  # HTTPS obligatorio — redirige HTTP a HTTPS automáticamente
  https_only = true

  tags = local.common_tags
}
