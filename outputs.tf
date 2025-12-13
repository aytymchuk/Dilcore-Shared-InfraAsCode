output "resourceGroupName" {
  value = azurerm_resource_group.resourceGroup.name
}

output "resource_group_location" {
  value = azurerm_resource_group.resourceGroup.location
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.analytics-workspace.id
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.analytics-workspace.name
}

output "application_insights_connection_string" {
  value     = azurerm_application_insights.app_insights.connection_string
  sensitive = true
}

output "app_configuration_id" {
  value = azurerm_app_configuration.app_configuration.id
}

output "app_configuration_endpoint" {
  value = azurerm_app_configuration.app_configuration.endpoint
}

output "container_app_env_id" {
  value = azurerm_container_app_environment.container_app_env.id
}

output "analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.analytics-workspace.id
}

output "appconf_dataowner_id" {
  value = azurerm_role_assignment.appconf_dataowner
}