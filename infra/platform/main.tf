# Create a new Azure Resource Group
resource "azurerm_resource_group" "resourceGroup" {
    name = "${var.env_name}-${var.componentName}-${var.region}-rg"
    location = local.resource_group_location
    tags = local.merged_tags
}

resource "azurerm_container_app" "api" {
  name                          = "${var.env_name}-${var.api_name}-${var.region}"
  container_app_environment_id  = var.container_app_env_id
  resource_group_name           = azurerm_resource_group.resourceGroup.name
  revision_mode                 = var.revision_mode

  identity {
      type = var.app_identity_type
  }

  template {
    container {
      name   = var.api_name
      image  = var.image_name
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
          name = "AppConfigEndpoint"
          value = var.app_config_endpoint
        }
      env {
        name = "ASPNETCORE_ENVIRONMENT"
        value = var.dotnet_env_name
      }
     }

     #min_replicas = 1
     #max_replicas = 1
  }

  ingress {
    target_port = 8080
    external_enabled = true
    traffic_weight {
          percentage = 100
          label = "blue"
          latest_revision = true
      }
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "appconfig_access" {
  scope = var.app_config_id
  role_definition_name = "App Configuration Data Reader"
  principal_id = azurerm_container_app.api.identity[0].principal_id

  depends_on = [
    azurerm_container_app.api
  ]
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${local.env_short}${var.api_name}${var.region}grainstorage"
  resource_group_name      = azurerm_resource_group.resourceGroup.name
  location                 = azurerm_resource_group.resourceGroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind            = "StorageV2"
  access_tier            = "Hot"
  is_hns_enabled         = false
  min_tls_version       = "TLS1_2"
  
  tags = var.tags
}

# Add Storage Blob Data Contributor role assignment for the API
resource "azurerm_role_assignment" "storage_access" {
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_container_app.api.identity[0].principal_id

  depends_on = [
    azurerm_container_app.api
  ]
}

# Add Storage Account connection string to App Configuration
resource "azurerm_app_configuration_key" "storage_connection_string" {
  configuration_store_id = var.app_config_id
  key                    = "General:GrainsConfig:StorageAccountConnectionString"
  value                  = azurerm_storage_account.storage_account.primary_connection_string
  
  depends_on = [
    azurerm_storage_account.storage_account
  ]
}

# Add Storage Account name to App Configuration
resource "azurerm_app_configuration_key" "storage_account_name" {
  configuration_store_id = var.app_config_id
  key                    = "General:GrainsConfig:StorageAccountName"
  value                  = azurerm_storage_account.storage_account.name
  
  depends_on = [
    azurerm_storage_account.storage_account
  ]
}

# Get current user
data "azurerm_client_config" "current" {}

# Add Azure Container App base URL to Azure App Configuration
resource "azurerm_app_configuration_key" "add_app_ai_connect_str" {
  configuration_store_id = var.app_config_id
  key                    = "General:PlatformApi:BaseUrl"
  value                  = "https://${azurerm_container_app.api.ingress[0].fqdn}"
  depends_on = [
    data.azurerm_client_config.current
  ]
}