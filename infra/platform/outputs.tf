output "resource_group" {
  value = azurerm_resource_group.resourceGroup.name
}

output "container_api_name" {
  value = azurerm_container_app.api.name
}

output "container_api_id" {
  value = azurerm_container_app.api.id
}

output "api_base_url" {
  value = "https://${azurerm_container_app.api.ingress[0].fqdn}"
}
