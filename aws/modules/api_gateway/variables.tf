variable "name" {
  description = "Nombre del API Gateway"
  type        = string
}

variable "description" {
  description = "Descripción del API"
  type        = string
  default     = ""
}

# CORS — configuración de acceso desde el navegador
variable "cors_allow_origins" {
  description = "Orígenes permitidos (ej: ['https://miapp.com'] o ['*'])"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_methods" {
  description = "Métodos HTTP permitidos"
  type        = list(string)
  default     = ["GET", "POST", "OPTIONS"]
}

variable "cors_allow_headers" {
  description = "Headers HTTP permitidos"
  type        = list(string)
  default     = ["Content-Type", "Authorization"]
}

variable "cors_max_age" {
  description = "Segundos que el browser cachea el preflight CORS"
  type        = number
  default     = 3600
}

# Integración con Lambda
variable "lambda_invoke_arn" {
  description = "invoke_arn de la Lambda a integrar (output del módulo lambda)"
  type        = string
}

variable "lambda_function_name" {
  description = "Nombre de la Lambda — necesario para el permiso de invocación"
  type        = string
}

# Rutas del API
variable "routes" {
  description = <<-EOT
    Lista de route_keys a registrar. Ejemplos:
      - "GET /hello"
      - "POST /items"
      - "$default"   ← catch-all para cualquier path no definido
  EOT
  type        = list(string)
  default     = ["$default"]
}

variable "log_retention_days" {
  description = "Días de retención de access logs en CloudWatch"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags a aplicar a todos los recursos del módulo"
  type        = map(string)
  default     = {}
}
