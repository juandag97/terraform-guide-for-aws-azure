"""
Workshop Terraform — Función Lambda (Python)

Esta función recibe eventos de API Gateway HTTP API (payload format v2)
y devuelve respuestas JSON.

Documentación del evento:
https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html#urls-payloads
"""

import json
import os
from datetime import datetime, timezone


def lambda_handler(event: dict, context) -> dict:
    """
    Punto de entrada principal de la Lambda.

    Args:
        event: Evento de API Gateway con info de la petición HTTP
        context: Contexto de ejecución de Lambda (tiempo restante, etc.)

    Returns:
        Respuesta HTTP en formato que entiende API Gateway
    """
    # Extraemos info del evento de API Gateway v2
    http_method = event.get("requestContext", {}).get("http", {}).get("method", "UNKNOWN")
    path        = event.get("rawPath", "/")
    query_params = event.get("queryStringParameters", {}) or {}

    # Variables de entorno inyectadas desde Terraform
    environment  = os.environ.get("ENVIRONMENT", "unknown")
    project_name = os.environ.get("PROJECT_NAME", "unknown")

    # Routing simple por path
    if path == "/hello" or path.endswith("/hello"):
        return _handle_hello(query_params, environment, project_name, context)
    else:
        return _handle_default(path, http_method, environment)


def _handle_hello(query_params: dict, environment: str, project_name: str, context) -> dict:
    """Responde al endpoint GET /hello"""
    name = query_params.get("name", "Mundo")

    body = {
        "message": f"¡Hola, {name}! 👋",
        "description": "Soy Kim. Este mensaje viene de una Lambda desplegada con Terraform.",
        "meta": {
            "project":     project_name,
            "environment": environment,
            "timestamp":   datetime.now(timezone.utc).isoformat(),
            "request_id":  context.aws_request_id,
            "function":    context.function_name,
        }
    }

    return _response(200, body)


def _handle_default(path: str, method: str, environment: str) -> dict:
    """Responde a cualquier otra ruta"""
    body = {
        "message": "Endpoint no encontrado",
        "available_routes": [
            "GET /hello",
            "GET /hello?name=TuNombre",
        ],
        "received_path":   path,
        "received_method": method,
        "environment":     environment,
    }

    return _response(404, body)


def _response(status_code: int, body: dict) -> dict:
    """Construye la respuesta en el formato que espera API Gateway"""
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type":                "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(body, ensure_ascii=False, indent=2),
    }
