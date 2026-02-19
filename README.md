# Terraform Guide — AWS (& Azure)

Guía práctica de Terraform con ejemplos reales. El foco principal es **AWS**, con ejemplos de **Azure** incorporándose progresivamente.

---

## Tabla de Contenidos

1. [Requisitos](#requisitos)
2. [Estructura del repositorio](#estructura-del-repositorio)
3. [Convenciones](#convenciones)
4. [Workflow básico](#workflow-básico)
5. [Módulos disponibles](#módulos-disponibles)
6. [Ejemplos](#ejemplos)
7. [Tips & buenas prácticas](#tips--buenas-prácticas)

---

## Requisitos

| Herramienta | Versión mínima | Instalación |
|---|---|---|
| Terraform | `>= 1.7` | [terraform.io](https://developer.hashicorp.com/terraform/install) |
| AWS CLI | `>= 2.x` | [aws amazon.com](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| Python | `>= 3.11` | Para los handlers de Lambda |

Configurar credenciales AWS antes de ejecutar:

```bash
aws configure
# o usando un perfil específico:
export AWS_PROFILE=my-profile
```

---

## Estructura del repositorio

```
tf/
├── README.md
├── CLAUDE.md
│
├── modules/                  # Módulos reutilizables
│   ├── lambda/
│   ├── api-gateway/
│   ├── dynamodb/
│   └── ...
│
└── examples/                 # Ejemplos completos listos para usar
    ├── aws/
    │   ├── lambda-api-gateway/   ← empezamos aquí
    │   ├── s3-static-site/
    │   └── ...
    └── azure/
        └── ...
```

Cada ejemplo y módulo sigue la misma estructura interna:

```
<ejemplo-o-modulo>/
├── main.tf           # Recursos principales
├── variables.tf      # Input variables
├── outputs.tf        # Outputs
├── versions.tf       # Required providers & terraform block
└── README.md         # Documentación específica
```

---

## Convenciones

### Naming de recursos

```hcl
# Patrón: {project}-{env}-{resource}-{descriptor}
resource "aws_lambda_function" "my_api" {
  function_name = "${var.project}-${var.env}-my-api"
}
```

### Variables

- Siempre con `description` y `type` explícito.
- Valores sensibles usan `sensitive = true`.
- Sin valores default cuando el dato es obligatorio (fuerza al caller a ser explícito).

```hcl
variable "env" {
  type        = string
  description = "Deployment environment: dev | staging | prod"
}

variable "db_password" {
  type        = string
  description = "Database root password"
  sensitive   = true
}
```

### Tags

Todos los recursos deben incluir al mínimo:

```hcl
tags = {
  Project     = var.project
  Environment = var.env
  ManagedBy   = "terraform"
}
```

### Formato

Siempre correr antes de hacer commit:

```bash
terraform fmt -recursive
terraform validate
```

---

## Workflow básico

```bash
# 1. Inicializar (primera vez o al agregar providers/módulos)
terraform init

# 2. Ver qué va a cambiar
terraform plan

# 3. Aplicar cambios
terraform apply

# 4. Destruir (¡cuidado en prod!)
terraform destroy
```

Para workspaces por ambiente:

```bash
terraform workspace new dev
terraform workspace select dev
terraform plan -var-file=envs/dev.tfvars
```

---

## Módulos disponibles

| Módulo | Descripción | Estado |
|---|---|---|
| `modules/lambda` | Lambda function con IAM role básico | WIP |
| `modules/api-gateway` | HTTP API Gateway con rutas | WIP |

---

## Ejemplos

| Ejemplo | Cloud | Descripción |
|---|---|---|
| [`examples/aws/lambda-api-gateway`](./examples/aws/lambda-api-gateway/) | AWS | API Python en Lambda + API Gateway con ruta POST |

---

## Tips & buenas prácticas

**State remoto** — Nunca versionar el `.tfstate`. Usar S3 + DynamoDB para locking:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-tf-state"
    key            = "project/env/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-lock"
    encrypt        = true
  }
}
```

**`terraform plan` antes de `apply`** — Siempre. En CI/CD guardar el plan como artefacto y aplicarlo en un segundo paso.

**Módulos versionados** — Al referenciar módulos remotos, pinear versión:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"
}
```

**Separar environments** — No usar `count` o `for_each` para separar prod de dev. Usar workspaces o directorios separados con su propio state.

**`lifecycle` para recursos críticos** — Proteger recursos que no deben borrarse accidentalmente:

```hcl
lifecycle {
  prevent_destroy = true
}
```
