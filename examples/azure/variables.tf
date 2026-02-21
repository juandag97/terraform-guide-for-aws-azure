variable "location" {
  description = "Región de Azure donde se despliegan los recursos"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en los recursos"
  type        = string
  default     = "workshop-tf"
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "node_version" {
  description = "Versión de Node.js para el App Service"
  type        = string
  default     = "NODE|20-lts"
}

variable "sku_name" {
  description = "SKU del App Service Plan. B1 es el más económico con siempre-encendido."
  type        = string
  default     = "B1"
}

variable "random_suffix" {
  description = "Sufijo aleatorio para nombres únicos globalmente (App Service name debe ser único)"
  type        = string
  default     = "x7k2"  # Cambia esto para evitar conflictos de nombres
}
