variable "env_name" {
  description = "The name of the environment (e.g., development, staging, production). Populated in the pipeline."
  type        = string
  validation {
    condition     = length(var.env_name) >= 2
    error_message = "The env_name must be at least 2 characters long."
  }
}

variable "region" {
  description = "The Azure region. Populated in the pipeline."
  type        = string
  validation {
    condition     = length(var.region) >= 3
    error_message = "The region must be at least 3 characters long."
  }
}

variable "componentName" {
  description = "The name of the component. Populated in the pipeline."
  default     = "shared"
  type        = string
  validation {
    condition     = length(var.componentName) >= 3
    error_message = "The componentName must be at least 3 characters long."
  }
}

# Local values for region mapping
locals {
  region_mapping = {
    "westeurope"    = "West Europe"
    "eastus"        = "East US"
    "eastus2"       = "East US 2"
    "westus"        = "West US"
    "westus2"       = "West US 2"
    "centralus"     = "Central US"
    "northeurope"   = "North Europe"
    "southeastasia" = "Southeast Asia"
    "eastasia"      = "East Asia"
    "australiaeast" = "Australia East"
    "uksouth"       = "UK South"
    "ukwest"        = "UK West"
    "canadacentral" = "Canada Central"
    "canadaeast"    = "Canada East"
    "japaneast"     = "Japan East"
    "japanwest"     = "Japan West"
    "koreacentral"  = "Korea Central"
    "koreasouth"    = "Korea South"
    "brazilsouth"   = "Brazil South"
    "southafricanorth" = "South Africa North"
    "uaenorth"      = "UAE North"
    "switzerlandnorth" = "Switzerland North"
    "germanywestcentral" = "Germany West Central"
    "norwayeast"    = "Norway East"
    "francecentral" = "France Central"
    "southindia"    = "South India"
    "centralindia"  = "Central India"
    "westindia"     = "West India"
  }
  
  resource_group_location = lookup(local.region_mapping, var.region, var.region)
}

variable "kind_of_group" {
  description = "The kind of group (e.g., shared, service-specific)"
  default     = "shared"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  default     = "laws" 
}

variable "log_analytics_sku" {
  description = "The SKU of the Log Analytics workspace"
  default     = "PerGB2018"
}

variable "app_config_name" {
  description = "The name of the Azure App Configuration instance"
  default     = "app-config"
}

variable "app_config_sku" {
  description = "The SKU of the Azure App Configuration instance"
  default     = "free"
}

variable "app_config_identity_type" {
  description = "The type of the Azure Managed Identity"
  default     = "UserAssigned"
}

variable "app_config_access_role" {
  description = "The role assigned to the App Configuration instance"
  default     = "App Configuration Data Owner"
}

variable "app_config_identity_name" {
  description = "Azure Managed Identity name"
  default     = "app-config-identity"
}

variable "application_insights_name" {
  description = "The name of the Azure Application Insights resource"
  default     = "appins"
}

variable "application_insights_kind" {
  description = "The kind of the Azure Application Insights resource"
  default     = "web"
}

variable "container_app_env_name" {
  description = "The name of the Azure Container App Environment resource"
  default     = "cont-app-env"
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {
    "CreatedBy" = "Terraform"
    "Environment" = "Development"
    "Kind" = "Shared"
  } 
}

variable "app_ins_connection_string_config_key" {
  description = "The key of the Azure Application Insights connection string in the App Configuration"
  default     = "General:TelemetryConfig:ApplicationInsightsConnectionString"
}