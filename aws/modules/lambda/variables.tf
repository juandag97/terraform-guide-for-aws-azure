variable "function_name" {
  description = "Nombre de la función Lambda"
  type        = string
}

variable "description" {
  description = "Descripción de la función Lambda"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Runtime de la función Lambda (ej: python3.12, nodejs20.x)"
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "Punto de entrada: archivo.funcion (ej: handler.lambda_handler)"
  type        = string
  default     = "handler.lambda_handler"
}

variable "timeout" {
  description = "Timeout de ejecución en segundos"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Memoria asignada en MB"
  type        = number
  default     = 128
}

variable "source_file" {
  description = "Ruta absoluta al archivo .py de la Lambda (se zipea automáticamente)"
  type        = string
}

variable "environment_variables" {
  description = "Variables de entorno disponibles dentro de la función"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "Días de retención de logs en CloudWatch"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags a aplicar a todos los recursos del módulo"
  type        = map(string)
  default     = {}
}
