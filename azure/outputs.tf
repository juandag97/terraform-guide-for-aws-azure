# ============================================================
# Outputs — valores que se muestran al terminar el `apply`
# ============================================================

output "app_url" {
  description = "URL pública del App Service (HTTPS)"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "hello_url" {
  description = "URL del endpoint /api/hello"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}/api/hello"
}

output "app_name" {
  description = "Nombre del App Service creado"
  value       = azurerm_linux_web_app.main.name
}

output "resource_group" {
  description = "Nombre del Resource Group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Región donde se desplegó la infraestructura"
  value       = azurerm_resource_group.main.location
}

output "service_plan" {
  description = "Nombre del App Service Plan"
  value       = azurerm_service_plan.main.name
}
