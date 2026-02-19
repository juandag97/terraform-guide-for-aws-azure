# Ejemplo: Lambda + API Gateway (POST /items)

API HTTP mínima en Python desplegada en AWS Lambda con API Gateway v2.

## Arquitectura

```
Cliente
  │
  │  POST /items
  ▼
┌─────────────────────┐
│   API Gateway v2    │  (HTTP API)
│   $default stage    │
└────────┬────────────┘
         │ AWS_PROXY (payload v2.0)
         ▼
┌─────────────────────┐
│   Lambda Function   │  python3.12
│   handler.py        │
└─────────────────────┘
```

## Recursos creados

| Recurso | Tipo |
|---|---|
| IAM Role | `aws_iam_role` |
| Lambda Function | `aws_lambda_function` |
| HTTP API | `aws_apigatewayv2_api` |
| Stage `$default` | `aws_apigatewayv2_stage` |
| Integration Lambda | `aws_apigatewayv2_integration` |
| Route `POST /items` | `aws_apigatewayv2_route` |

## Variables

| Variable | Descripción | Default |
|---|---|---|
| `project` | Nombre del proyecto (prefijo de recursos) | `tf-guide` |
| `env` | Ambiente: `dev`, `staging`, `prod` | `dev` |
| `aws_region` | Región AWS | `us-east-1` |

## Outputs

| Output | Descripción |
|---|---|
| `api_endpoint` | URL base del HTTP API |
| `post_items_url` | URL completa para `POST /items` |
| `lambda_function_name` | Nombre de la función Lambda |
| `lambda_arn` | ARN de la función Lambda |

## Cómo ejecutarlo

```bash
# 1. Inicializar
terraform init

# 2. Ver el plan
terraform plan

# 3. Aplicar
terraform apply

# 4. Probar el endpoint
curl -X POST $(terraform output -raw post_items_url) \
  -H "Content-Type: application/json" \
  -d '{"name": "widget", "description": "my first item"}'
```

Respuesta esperada:

```json
{
  "item": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "widget",
    "description": "my first item",
    "env": "dev"
  }
}
```

## Limpiar

```bash
terraform destroy
```
