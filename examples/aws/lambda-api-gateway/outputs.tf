output "api_endpoint" {
  description = "Base URL of the HTTP API"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "post_items_url" {
  description = "Full URL for the POST /items route"
  value       = "${aws_apigatewayv2_stage.default.invoke_url}/items"
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api.function_name
}

output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.api.arn
}
