# Create a new Azure Resource Group
resource "azurerm_resource_group" "resourceGroup" {
    name = "${var.env_name}-${var.componentName}-${var.region}-rg"
    location = local.resource_group_location
    tags = var.tags
}
