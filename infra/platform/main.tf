# Create a new Azure Resource Group
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resourceGroup" {
  name     = "${var.env_name}-${var.componentName}-${var.region}-rg"
  location = local.resource_group_location
  tags     = local.merged_tags
}

resource "azurerm_container_app" "api" {
  name                         = local.container_app_name
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
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name  = "AppConfigEndpoint"
        value = var.app_config_endpoint
      }
      env {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = var.dotnet_env_name
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

# Add Storage Blob Data Contributor role assignment for the API
resource "azurerm_role_assignment" "storage_access" {
  scope                = azurerm_storage_account.grain_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_container_app.api.identity[0].principal_id

  depends_on = [
    azurerm_container_app.api
  ]
}

resource "random_password" "sql_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mssql_server" "sql" {
  name                         = "${local.env_short}-${var.api_name}-sql"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  location                     = azurerm_resource_group.resourceGroup.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = random_password.sql_admin_password.result
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "terraform-admin"
    object_id      = data.azurerm_client_config.current.object_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "sqldb" {
  name                        = var.sql_database_name
  server_id                   = azurerm_mssql_server.sql.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name                    = var.sql_sku_name
  auto_pause_delay_in_minutes = var.sql_auto_pause_delay
  min_capacity                = var.sql_min_capacity
  storage_account_type        = "Local"

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
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
      # Generate a SQL script
      echo "CREATE USER [${azurerm_container_app.api.name}] FROM EXTERNAL PROVIDER;" > create_user.sql
      echo "ALTER ROLE db_datareader ADD MEMBER [${azurerm_container_app.api.name}];" >> create_user.sql
      echo "ALTER ROLE db_datawriter ADD MEMBER [${azurerm_container_app.api.name}];" >> create_user.sql

      # Execute with sqlcmd
      # Note: This requires sqlcmd tool and valid Azure AD context.
      echo "Executing SQL script to create user..."
      sqlcmd -S ${azurerm_mssql_server.sql.fully_qualified_domain_name} -d ${azurerm_mssql_database.sqldb.name} --authentication-method=ActiveDirectoryDefault -i create_user.sql
      
      # Cleanup
      rm create_user.sql
    EOT

    interpreter = ["/bin/bash", "-c"]
    on_failure  = continue
  }
}
