# Create a new Azure Resource Group
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resourceGroup" {
  name     = "${var.env_name}-${var.componentName}-${var.region}-rg"
  location = local.resource_group_location
  tags     = local.merged_tags
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
