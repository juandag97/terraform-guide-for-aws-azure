variable "location" {
  description = "Región de Azure donde se despliegan los recursos"
  type        = string
  default     = "centralus"
}

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en los recursos"
  type        = string
  default     = "workshop-tf-marzo"
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "node_version" {
  description = "Versión de Node.js para el App Service"
  type        = string
  default     = "20-lts"
}

variable "sku_name" {
  description = "SKU del App Service Plan. F1 es el más económico con siempre-encendido."
  type        = string
  default     = "F1"
}

variable "random_suffix" {
  description = "Sufijo aleatorio para nombres únicos globalmente (App Service name debe ser único)"
  type        = string
  default     = ""  # Cambia esto para evitar conflictos de nombres
}
