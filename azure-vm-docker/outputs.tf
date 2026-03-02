# -----------------------------------------------
# Outputs - URLs y datos útiles post-deploy
# -----------------------------------------------

output "app_url" {
  description = "URL pública de la Container App (HTTPS)"
  value       = "https://${azurerm_container_app.main.ingress[0].fqdn}"
}

output "container_app_name" {
  description = "Nombre de la Container App en Azure"
  value       = azurerm_container_app.main.name
}

output "resource_group" {
  description = "Resource Group donde vive la infraestructura"
  value       = azurerm_resource_group.main.name
}

output "environment_name" {
  description = "Nombre del Container App Environment"
  value       = azurerm_container_app_environment.main.name
}
