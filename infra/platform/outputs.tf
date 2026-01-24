output "resource_group" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resourceGroup.name
}

output "container_api_name" {
  description = "The name of the container app"
  value       = azurerm_container_app.api.name
}

output "container_api_id" {
  description = "The ID of the container app"
  value       = azurerm_container_app.api.id
}

output "api_base_url" {
  description = "The base URL for the API"
  value       = "https://${azurerm_container_app.api.ingress[0].fqdn}"
}

output "api_fqdn" {
  description = "The FQDN for the API container app"
  value       = azurerm_container_app.api.ingress[0].fqdn
}

output "container_ai_core_name" {
  description = "The name of the ai-core container app"
  value       = azurerm_container_app.ai_core.name
}

output "container_ai_core_id" {
  description = "The ID of the ai-core container app"
  value       = azurerm_container_app.ai_core.id
}

output "ai_core_base_url" {
  description = "The base URL for the ai-core"
  value       = "https://${azurerm_container_app.ai_core.ingress[0].fqdn}"
}

output "ai_core_fqdn" {
  description = "The FQDN for the ai-core container app"
  value       = azurerm_container_app.ai_core.ingress[0].fqdn
}

output "container_web_app_name" {
  description = "The name of the web-app container app"
  value       = azurerm_container_app.web_app.name
}

output "container_web_app_id" {
  description = "The ID of the web-app container app"
  value       = azurerm_container_app.web_app.id
}

output "web_app_base_url" {
  description = "The base URL for the web-app"
  value       = "https://${azurerm_container_app.web_app.ingress[0].fqdn}"
}

output "web_app_fqdn" {
  description = "The FQDN for the web-app container app"
  value       = azurerm_container_app.web_app.ingress[0].fqdn
}

output "grain_storage_account_connection_string" {
  description = "The primary connection string for the grain storage account"
  value       = azurerm_storage_account.grain_storage_account.primary_connection_string
  sensitive   = true
}

output "grain_storage_account_name" {
  description = "The name of the grain storage account"
  value       = azurerm_storage_account.grain_storage_account.name
}

