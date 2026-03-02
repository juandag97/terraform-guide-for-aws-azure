# ============================================================
# Módulo Lambda — Reutilizable
# Recursos: IAM Role + CloudWatch Log Group + Lambda Function
# ============================================================

# Zipea el archivo Python antes de subirlo a AWS
data "archive_file" "this" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${path.module}/function.zip"
}

# Política trust: permite que Lambda asuma este rol
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Rol IAM para la Lambda
resource "aws_iam_role" "this" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

# Adjunta permisos básicos de ejecución (incluye escritura en CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Log group con retención controlada
# Se crea antes de la Lambda para que AWS no lo cree sin configuración
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# Función Lambda
resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  description      = var.description
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = var.runtime
  handler          = var.handler
  role             = aws_iam_role.this.arn
  timeout          = var.timeout
  memory_size      = var.memory_size

  environment {
    variables = var.environment_variables
  }

  depends_on = [
    aws_iam_role_policy_attachment.basic_execution,
    aws_cloudwatch_log_group.this,
  ]

  tags = var.tags
}
