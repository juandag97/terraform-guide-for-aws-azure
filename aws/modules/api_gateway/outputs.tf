output "api_endpoint" {
  description = "URL base del API Gateway (sin path)"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_id" {
  description = "ID del API Gateway"
  value       = aws_apigatewayv2_api.this.id
}

output "execution_arn" {
  description = "ARN de ejecución — usado para configurar permisos Lambda adicionales"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "stage_id" {
  description = "ID del stage $default"
  value       = aws_apigatewayv2_stage.default.id
}

output "log_group_name" {
  description = "Nombre del log group de access logs en CloudWatch"
  value       = aws_cloudwatch_log_group.this.name
}
