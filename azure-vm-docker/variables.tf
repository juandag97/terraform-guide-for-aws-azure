# -----------------------------------------------
# Variables del workshop - Azure Container App
# -----------------------------------------------

variable "resource_group_name" {
  description = "Nombre del Resource Group en Azure"
  type        = string
  default     = "rg-workshop-terraform"
}

variable "location" {
  description = "Región de Azure donde se desplegará la infraestructura"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Nombre base del proyecto (se usa para nombrar recursos)"
  type        = string
  default     = "workshop"
}

variable "container_image" {
  description = "Imagen Docker a desplegar (ej: mcr.microsoft.com/azuredocs/containerapps-helloworld:latest)"
  type        = string
  # Imagen pública de ejemplo - en producción usar ACR propio
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_cpu" {
  description = "CPU asignada al contenedor (en cores)"
  type        = number
  default     = 0.25
}

variable "container_memory" {
  description = "Memoria asignada al contenedor"
  type        = string
  default     = "0.5Gi"
}

variable "min_replicas" {
  description = "Mínimo de réplicas (0 = escala a cero cuando no hay tráfico)"
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Máximo de réplicas"
  type        = number
  default     = 3
}
