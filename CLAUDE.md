# CLAUDE.md — Terraform Guide Project

## Contexto del proyecto

Este repositorio es una **guía práctica de Terraform** con ejemplos reales, principalmente en AWS y luego Azure.
El objetivo es tener código listo para usar y aprender de él.

---

## Estructura esperada

```
tf/
├── modules/        # Módulos reutilizables (sin estado propio)
├── examples/
│   ├── aws/        # Ejemplos AWS
│   └── azure/      # Ejemplos Azure (cuando se agreguen)
```

Cada módulo y ejemplo sigue la estructura estándar:
`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`

---

## Convenciones de código

### Terraform
- Versión mínima: `>= 1.7`
- Provider AWS: usar `~> 5.0`
- Provider AzureRM: usar `~> 3.0` (cuando aplique)
- Siempre incluir `versions.tf` con el bloque `terraform { required_providers {} }`
- Siempre correr `terraform fmt` antes de entregar código
- Tags obligatorios en todos los recursos AWS: `Project`, `Environment`, `ManagedBy = "terraform"`

### Naming
- Recursos: `{project}-{env}-{descriptor}` usando variables, nunca hardcodeado
- Variables locales (`locals`) para valores derivados o compuestos
- Nombres de variables en `snake_case`

### Lambda + Python
- Runtime: `python3.12` por defecto
- Handler: `handler.lambda_handler`
- El código Python va en `src/` dentro del ejemplo
- Zipear con `archive_file` data source, no subir zips pre-compilados al repo
- IAM role mínimo: solo los permisos necesarios (least privilege)

### API Gateway
- Usar **HTTP API** (`aws_apigatewayv2_api`) no REST API, salvo que se necesite algo específico de REST
- Integración tipo `AWS_PROXY`
- Stage por defecto: `$default` con auto-deploy

---

## Lo que NO hacer

- No hardcodear ARNs, account IDs, ni region en el código — usar `data "aws_caller_identity"` y `data "aws_region"`
- No versionar `.tfstate`, `.tfvars` con secrets, ni el directorio `.terraform/`
- No mezclar recursos de múltiples providers en un solo `main.tf` sin justificación clara
- No crear módulos para cosas que se usan una sola vez

---

## Al agregar un nuevo ejemplo

1. Crear carpeta en `examples/aws/<nombre>/` o `examples/azure/<nombre>/`
2. Incluir los 5 archivos base: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`
3. Agregar una fila en la tabla de Ejemplos del `README.md` raíz
4. El README del ejemplo debe incluir: descripción, arquitectura (texto o ASCII), variables requeridas, outputs, y cómo ejecutarlo

---

## Al agregar un nuevo módulo

1. Crear carpeta en `modules/<nombre>/`
2. El módulo NO debe tener estado propio ni backend
3. Documentar todos los inputs y outputs en el `README.md` del módulo
4. Actualizar la tabla de Módulos en el `README.md` raíz

---

## Idioma

- Código y nombres de variables: **inglés**
- Comentarios en el código: **inglés**
- Documentación (READMEs, este archivo): **español**
