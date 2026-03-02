output "function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "ARN de invocación — el que usa API Gateway para llamar a la Lambda"
  value       = aws_lambda_function.this.invoke_arn
}

output "log_group_name" {
  description = "Nombre del log group en CloudWatch"
  value       = aws_cloudwatch_log_group.this.name
}

output "role_arn" {
  description = "ARN del rol IAM asociado a la Lambda"
  value       = aws_iam_role.this.arn
}
