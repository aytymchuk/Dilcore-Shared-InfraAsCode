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

output "grain_storage_account_connection_string" {
  description = "The primary connection string for the grain storage account"
  value       = azurerm_storage_account.grain_storage_account.primary_connection_string
  sensitive   = true
}

output "grain_storage_account_name" {
  description = "The name of the grain storage account"
  value       = azurerm_storage_account.grain_storage_account.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server."
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "sql_server_name" {
  description = "The name of the SQL Server."
  value       = azurerm_mssql_server.sql.name
}

output "sql_server_id" {
  description = "The ID of the SQL Server."
  value       = azurerm_mssql_server.sql.id
}

output "sql_database_name" {
  description = "The name of the SQL Database."
  value       = azurerm_mssql_database.sqldb.name
}

output "sql_connection_string" {
  description = "The connection string for the SQL Database using Managed Identity."
  value       = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldb.name};Authentication=Active Directory Managed Identity;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}
