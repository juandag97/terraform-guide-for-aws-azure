# ============================================================
# Outputs — valores que se muestran al terminar el `apply`
# Se pueden consultar luego con: terraform output <nombre>
# ============================================================

output "api_endpoint" {
  description = "URL base del API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "hello_url" {
  description = "URL completa del endpoint GET /hello"
  value       = "${module.api_gateway.api_endpoint}/hello"
}

output "lambda_name" {
  description = "Nombre de la función Lambda creada"
  value       = module.lambda.function_name
}

output "lambda_arn" {
  description = "ARN de la función Lambda"
  value       = module.lambda.function_arn
}

output "lambda_log_group" {
  description = "Log group de CloudWatch para la Lambda"
  value       = module.lambda.log_group_name
}

output "api_id" {
  description = "ID del API Gateway"
  value       = module.api_gateway.api_id
}

output "region" {
  description = "Región donde se desplegó la infraestructura"
  value       = var.aws_region
}
