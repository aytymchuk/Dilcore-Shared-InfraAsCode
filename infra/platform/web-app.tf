resource "azurerm_container_app" "web_app" {
  name                         = local.web_app_app_name
  container_app_environment_id = var.container_app_env_id
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  revision_mode                = var.revision_mode

  identity {
    type = var.app_identity_type
  }

  template {
    container {
      name   = var.web_app_name
      image  = var.image_name # Placeholder, usually updated via CI/CD
      cpu    = var.web_app_container_cpu
      memory = var.web_app_container_memory

      env {
        name  = "AppConfigEndpoint"
        value = var.app_config_endpoint
      }
      env {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = var.dotnet_env_name
      }
      env {
        name  = "ASPNETCORE_HTTP_PORTS"
        value = "8080"
      }
    }

    #min_replicas = 1
    #max_replicas = 1
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

resource "azurerm_role_assignment" "web_app_appconfig_access" {
  scope                = var.app_config_id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_container_app.web_app.identity[0].principal_id

  depends_on = [
    azurerm_container_app.web_app
  ]
}
