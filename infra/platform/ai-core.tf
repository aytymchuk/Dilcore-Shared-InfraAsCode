resource "azurerm_container_app" "ai_core" {
  name                         = local.ai_core_app_name
  container_app_environment_id = var.container_app_env_id
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  revision_mode                = var.revision_mode

  identity {
    type = var.app_identity_type
  }

  template {
    container {
      name   = var.ai_core_name
      image  = var.image_name # Placeholder, usually updated via CI/CD
      cpu    = var.ai_core_container_cpu
      memory = var.ai_core_container_memory

      env {
        name  = "AZURE_APPCONFIG_ENDPOINT"
        value = var.app_config_endpoint
      }
      env {
        name  = "ENVIRONMENT"
        value = var.env_name
      }
    }
  }

  ingress {
    target_port      = 8080
    external_enabled = true
    traffic_weight {
      percentage      = 100
      label           = "blue"
      latest_revision = true
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image
    ]
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "ai_core_appconfig_access" {
  scope                = var.app_config_id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_container_app.ai_core.identity[0].principal_id

  depends_on = [
    azurerm_container_app.ai_core
  ]
}
