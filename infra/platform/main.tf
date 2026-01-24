# Create a new Azure Resource Group
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resourceGroup" {
  name     = "${var.env_name}-${var.componentName}-${var.region}-rg"
  location = local.resource_group_location
  tags     = local.merged_tags
}
