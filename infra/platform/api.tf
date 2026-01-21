resource "azurerm_container_app" "api" {
  name                         = local.api_app_name
  container_app_environment_id = var.container_app_env_id
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  revision_mode                = var.revision_mode

  identity {
    type = var.app_identity_type
  }

  template {
    container {
      name   = var.api_name
      image  = var.image_name
      cpu    = var.api_container_cpu
      memory = var.api_container_memory

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

resource "azurerm_role_assignment" "appconfig_access" {
  scope                = var.app_config_id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_container_app.api.identity[0].principal_id

  depends_on = [
    azurerm_container_app.api
  ]
}

resource "azurerm_storage_account" "grain_storage_account" {
  name                     = "${local.env_short}${var.api_name}grainstorage"
  resource_group_name      = azurerm_resource_group.resourceGroup.name
  location                 = azurerm_resource_group.resourceGroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  is_hns_enabled           = false
  min_tls_version          = "TLS1_2"

  # Security Hardening
  allow_nested_items_to_be_public = false # Replaces allow_blob_public_access

  # Enabling public network access is required because the Container App 
  # is not VNet-integrated and lacks Private Endpoint connectivity.
  public_network_access_enabled = true

  tags = var.tags
}

# Add Storage Table Data Contributor role assignment for the API
resource "azurerm_role_assignment" "storage_access" {
  scope                = azurerm_storage_account.grain_storage_account.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_container_app.api.identity[0].principal_id

  depends_on = [
    azurerm_container_app.api
  ]
}

# Automated SQL User Creation for Managed Identity
resource "null_resource" "create_sql_user" {
  depends_on = [
    azurerm_mssql_database.sqldb,
    azurerm_container_app.api,
    azurerm_mssql_firewall_rule.allow_azure_services
  ]

  triggers = {
    sql_user_id = azurerm_container_app.api.identity[0].principal_id
  }

  provisioner "local-exec" {
    command = <<EOT
      set -e
      SCRIPT_FILE=$(mktemp)
      cat > "$SCRIPT_FILE" <<'SQL'
      IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = '${azurerm_container_app.api.name}')
      BEGIN
        CREATE USER [${azurerm_container_app.api.name}] FROM EXTERNAL PROVIDER;
      END

      IF IS_ROLEMEMBER('db_datareader', '${azurerm_container_app.api.name}') = 0
      BEGIN
        ALTER ROLE db_datareader ADD MEMBER [${azurerm_container_app.api.name}];
      END

      IF IS_ROLEMEMBER('db_datawriter', '${azurerm_container_app.api.name}') = 0
      BEGIN
        ALTER ROLE db_datawriter ADD MEMBER [${azurerm_container_app.api.name}];
      END
SQL

      echo "Executing SQL script to create user and assign roles..."
      if ! sqlcmd -S ${azurerm_mssql_server.sql.fully_qualified_domain_name} -d ${azurerm_mssql_database.sqldb.name} --authentication-method=ActiveDirectoryDefault -i "$SCRIPT_FILE"; then
        echo "SQL execution failed"
        rm -f "$SCRIPT_FILE"
        exit 1
      fi
      
      rm -f "$SCRIPT_FILE"
    EOT

    interpreter = ["/bin/bash", "-c"]
  }
}
