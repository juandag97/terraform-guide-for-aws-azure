import json
import os


def lambda_handler(event: dict, context) -> dict:
    """
    POST /items handler.

    Expected body:
        { "name": "string", "description": "string" }

    Returns:
        201 with the created item (echo for now).
    """
    env = os.environ.get("ENV", "unknown")

    try:
        body = json.loads(event.get("body") or "{}")
    except json.JSONDecodeError:
        return _response(400, {"error": "Invalid JSON body"})

    name = body.get("name")
    if not name:
        return _response(400, {"error": "'name' is required"})

    item = {
        "id": _generate_id(),
        "name": name,
        "description": body.get("description", ""),
        "env": env,
    }

    return _response(201, {"item": item})


def _response(status_code: int, body: dict) -> dict:
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }


def _generate_id() -> str:
    import uuid
    return str(uuid.uuid4())
