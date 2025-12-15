# Create a new Azure Resource Group
resource "azurerm_resource_group" "resourceGroup" {
    name = "${var.env_name}-${var.componentName}-${var.region}-rg"
    location = local.resource_group_location
    tags = var.tags
}

# Log analytics workspace
resource "azurerm_log_analytics_workspace" "analytics-workspace" {
  name = "${var.env_name}-${var.log_analytics_workspace_name}-${var.kind_of_group}-${var.region}"
  location = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  sku = var.log_analytics_sku
  tags = var.tags
}

# Managed Identity
resource "azurerm_user_assigned_identity" "app_config_identity" {
  name = "${var.env_name}-${var.app_config_identity_name}-${var.kind_of_group}-${var.region}"
  location = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  tags = var.tags
}

# Azure App Configuration with Managed Identity
resource "azurerm_app_configuration" "app_configuration" {
  name = "${var.env_name}-${var.app_config_name}-${var.kind_of_group}-${var.region}"
  location = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  sku = var.app_config_sku
  identity {
    type = var.app_config_identity_type
    identity_ids = [  azurerm_user_assigned_identity.app_config_identity.id ]
  }
  tags = var.tags
}

# Get current user
data "azurerm_client_config" "current" {}

# Assign current session user as a App Config Data Owner
resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_app_configuration.app_configuration.id
  role_definition_name = var.app_config_access_role
  principal_id         = data.azurerm_client_config.current.object_id
}

# Create Azure Application Insights
resource "azurerm_application_insights" "app_insights" {
  name = "${var.env_name}-${var.application_insights_name}-${var.kind_of_group}-${var.region}"
  location = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  application_type = var.application_insights_kind
  workspace_id = azurerm_log_analytics_workspace.analytics-workspace.id
  tags = var.tags
}

#Container App Environment
resource "azurerm_container_app_environment" "container_app_env" {
  name = "${var.env_name}-${var.container_app_env_name}-${var.kind_of_group}-${var.region}"
  location = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics-workspace.id
  tags = var.tags
}

# Add Azure Application Insights Connection String to Azure App Configuration
resource "azurerm_app_configuration_key" "add_app_ai_connect_str" {
  configuration_store_id = azurerm_app_configuration.app_configuration.id
  key                    = var.app_ins_connection_string_config_key
  value                  = azurerm_application_insights.app_insights.connection_string
  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]
}