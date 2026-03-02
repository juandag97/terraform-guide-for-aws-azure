# ============================================================
# Workshop Terraform — AWS
# Orquesta módulos de Lambda y API Gateway
# ============================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Requerido por el módulo lambda para zipear el código Python
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------
# DATOS LOCALES
# Prefijo y tags compartidos entre todos los recursos
# ------------------------------------------------------------
locals {
  prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------
# MÓDULO LAMBDA
# Empaqueta el código Python y crea la función con su rol IAM
# ------------------------------------------------------------
module "lambda" {
  source = "./modules/lambda"

  function_name = "${local.prefix}-api"
  description   = "Función demo del workshop de Terraform"

  # Código fuente — path.module apunta al directorio raíz del proyecto
  source_file = "${path.module}/lambda/handler.py"

  # Runtime y punto de entrada
  runtime = var.lambda_runtime
  handler = "handler.lambda_handler"

  # Recursos
  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory

  # Variables de entorno accesibles desde Python con os.environ
  environment_variables = {
    ENVIRONMENT  = var.environment
    PROJECT_NAME = var.project_name
  }

  log_retention_days = 7
  tags               = local.common_tags
}

# ------------------------------------------------------------
# MÓDULO API GATEWAY
# HTTP API v2 que enruta las peticiones a la Lambda
# ------------------------------------------------------------
module "api_gateway" {
  source = "./modules/api_gateway"

  name        = "${local.prefix}-api"
  description = "API demo del workshop de Terraform"

  # Conecta el API Gateway con la Lambda del módulo anterior
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name

  # Rutas registradas — el módulo crea un recurso por cada una
  routes = [
    "GET /hello", # endpoint principal
    "$default",   # catch-all para cualquier otro path
  ]

  # CORS — permite llamadas desde el navegador
  cors_allow_origins = ["*"]
  cors_allow_methods = ["GET", "POST", "OPTIONS"]
  cors_allow_headers = ["Content-Type", "Authorization"]

  log_retention_days = 7
  tags               = local.common_tags
}
