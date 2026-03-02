# Workshop: Terraform con AWS y Azure

> **Nivel:** Introductorio
> **Duración estimada:** 3-4 horas
> **Requisitos previos:** Conocimientos básicos de terminal y programación

---

## ¿Qué vas a aprender?

- Qué es Infrastructure as Code (IaC) y por qué importa
- Conceptos fundamentales de Terraform: providers, recursos, variables, outputs, state
- Estructura y sintaxis básica de archivos `.tf`
- Deploy de un servicio web completo en **AWS** (API Gateway + Lambda con Python)
- Deploy de un servicio web completo en **Azure** (App Service con Node.js)

---

## Requisitos de instalación

### Terraform
```bash
# macOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Verificar
terraform -version
```

### AWS CLI
```bash
brew install awscli
aws configure   # Ingresa tu Access Key, Secret y región
```

### Azure CLI
```bash
brew install azure-cli
az login        # Abre el navegador para autenticarte
```

---

## Estructura del Repositorio

```
terraform-020326/
├── slides/             # Presentación del workshop
│   └── generate_pptx.py
├── aws/                # Ejemplo: API Gateway + Lambda (Python)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── lambda/
│       └── handler.py
└── azure/              # Ejemplo: App Service (Node.js)
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── app/
        ├── index.js
        └── package.json
```

---

## Ejemplo 1 — AWS: API Gateway + Lambda

**Lo que se despliega:**
```
Internet → API Gateway (HTTP API) → Lambda (Python) → Respuesta JSON
```

### Pasos

```bash
cd aws/

# 1. Inicializar Terraform (descarga el provider de AWS)
terraform init

# 2. Ver qué va a crear
terraform plan

# 3. Crear la infraestructura
terraform apply

# 4. Probar el endpoint (URL aparece en los outputs)
curl $(terraform output -raw api_endpoint)/hello

# 5. Destruir cuando termines
terraform destroy
```

### Lo que se crea en AWS
| Recurso            | Tipo                        |
|--------------------|-----------------------------|
| IAM Role           | Permisos para Lambda        |
| Lambda Function    | Función Python 3.12         |
| API Gateway        | HTTP API (v2)               |
| API Integration    | Lambda → API GW             |
| API Route          | GET /hello                  |
| API Stage          | $default (auto-deploy)      |
| CloudWatch Log Group| Logs de Lambda             |

---

## Ejemplo 2 — Azure: App Service con Node.js

**Lo que se despliega:**
```
Internet → App Service Plan → App Service (Node 20 LTS) → Express.js API
```

### Pasos

```bash
cd azure/

# 1. Autenticarse con Azure
az login

# 2. Inicializar Terraform (descarga el provider de Azure)
terraform init

# 3. Ver qué va a crear
terraform plan

# 4. Crear la infraestructura (puede tardar 2-3 min)
terraform apply

# 5. Probar el endpoint
curl $(terraform output -raw app_url)/api/hello

# 6. Destruir cuando termines
terraform destroy
```

### Lo que se crea en Azure
| Recurso            | Tipo                              |
|--------------------|-----------------------------------|
| Resource Group     | Contenedor de recursos            |
| App Service Plan   | Plan B1 (Free tier)               |
| App Service        | Linux + Node 20 LTS               |
| App Settings       | Variables de entorno              |

---

## Conceptos Clave de Terraform

### Archivos principales
| Archivo          | Propósito                                  |
|------------------|--------------------------------------------|
| `main.tf`        | Recursos principales a crear               |
| `variables.tf`   | Definición de variables configurables      |
| `outputs.tf`     | Valores que se muestran al terminar        |
| `terraform.tfvars`| Valores concretos para las variables      |
| `.terraform/`    | Providers descargados (no commitear)       |
| `terraform.tfstate`| Estado actual de la infra (cuidado!)    |

### Bloque básico de recurso
```hcl
resource "aws_lambda_function" "mi_funcion" {
  function_name = "hola-mundo"
  runtime       = "python3.12"
  handler       = "handler.lambda_handler"
  # ...
}
```

### Variables
```hcl
# variables.tf
variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

# Uso en main.tf
provider "aws" {
  region = var.region
}
```

### Outputs
```hcl
# outputs.tf
output "api_endpoint" {
  value       = aws_apigatewayv2_api.api.api_endpoint
  description = "URL del API Gateway"
}
```

---

## Generar la Presentación PPT

```bash
cd slides/
pip install python-pptx
python3 generate_pptx.py
# Genera: slides/workshop-terraform.pptx
```

---

## Referencias

- [Documentación oficial de Terraform](https://developer.hashicorp.com/terraform/docs)
- [Terraform Registry - AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Terraform Registry - Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [Azure Free Tier](https://azure.microsoft.com/free/)
