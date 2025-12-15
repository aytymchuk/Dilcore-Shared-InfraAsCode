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

  default_tags = {
    CreatedBy   = "Terraform"
    Environment = var.env_name
    Kind        = var.componentName
  }

  merged_tags = merge(local.default_tags, var.tags)
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "api_name" {
  description = "The name of the application."
  type        = string
}

variable "container_app_env_id" {
  description = "The ID of the Container App Environment."
  type        = string
  default = "$(SHARED_CONTAINER_APP_ENV_ID)"
}

variable "revision_mode" {
  description = "The revision mode for the Container App (e.g., Single, Multiple)."
  type        = string
  default     = "Single"
}

variable "app_identity_type" {
  description = "The type of identity for the Container App."
  type        = string
  default     = "SystemAssigned"
}

variable "image_name" {
  description = "The container image name."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_cpu" {
  description = "The number of CPU cores for the container."
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "The amount of memory for the container (e.g., 1Gi, 2Gi)."
  type        = string
  default     = "1.0Gi"
}

variable "app_config_endpoint" {
  description = "The endpoint of the App Configuration."
  type        = string
  default = "$(SHARED_APP_CONFIGURATION_ENDPOINT)"
}

variable "dotnet_env_name" {
  description = "The ASP.NET Core environment name (e.g., Development, Production)."
  type        = string
  default     = "Development"
}

variable "app_config_id" {
  description = "The ID of the App Configuration store."
  type        = string
  default = "$(SHARED_APP_CONFIGURATION_ID)"
}