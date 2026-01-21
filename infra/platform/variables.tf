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
    "westeurope"         = "West Europe"
    "eastus"             = "East US"
    "eastus2"            = "East US 2"
    "westus"             = "West US"
    "westus2"            = "West US 2"
    "centralus"          = "Central US"
    "northeurope"        = "North Europe"
    "southeastasia"      = "Southeast Asia"
    "eastasia"           = "East Asia"
    "australiaeast"      = "Australia East"
    "uksouth"            = "UK South"
    "ukwest"             = "UK West"
    "canadacentral"      = "Canada Central"
    "canadaeast"         = "Canada East"
    "japaneast"          = "Japan East"
    "japanwest"          = "Japan West"
    "koreacentral"       = "Korea Central"
    "koreasouth"         = "Korea South"
    "brazilsouth"        = "Brazil South"
    "southafricanorth"   = "South Africa North"
    "uaenorth"           = "UAE North"
    "switzerlandnorth"   = "Switzerland North"
    "germanywestcentral" = "Germany West Central"
    "norwayeast"         = "Norway East"
    "francecentral"      = "France Central"
    "southindia"         = "South India"
    "centralindia"       = "Central India"
    "westindia"          = "West India"
  }

  resource_group_location = lookup(local.region_mapping, var.region, var.region)

  env_short = substr(lower(var.env_name), 0, 3)

  api_app_name     = lower(replace("${local.env_short}-${var.api_name}", "/[^a-z0-9-]/", ""))
  ai_core_app_name = lower(replace("${local.env_short}-${var.ai_core_name}", "/[^a-z0-9-]/", ""))
  web_app_app_name = lower(replace("${local.env_short}-${var.web_app_name}", "/[^a-z0-9-]/", ""))

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
  default     = "api"
  validation {
    condition     = length(var.api_name) <= 8
    error_message = "The api_name must be at most 8 characters long to ensure storage account name limits."
  }
}

variable "ai_core_name" {
  description = "The name of the AI Core application."
  type        = string
  default     = "ai-core"
}

variable "web_app_name" {
  description = "The name of the Web App application."
  type        = string
  default     = "web-app"
}

variable "container_app_env_id" {
  description = "The ID of the Container App Environment."
  type        = string
  default     = "$(SHARED_CONTAINER_APP_ENV_ID)"
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

variable "api_container_cpu" {
  description = "The number of CPU cores for the API container."
  type        = number
  default     = 0.5
}

variable "api_container_memory" {
  description = "The amount of memory for the API container (e.g., 1Gi, 2Gi)."
  type        = string
  default     = "1.0Gi"
}

variable "ai_core_container_cpu" {
  description = "The number of CPU cores for the AI Core container."
  type        = number
  default     = 0.5
}

variable "ai_core_container_memory" {
  description = "The amount of memory for the AI Core container (e.g., 1Gi, 2Gi)."
  type        = string
  default     = "1.0Gi"
}

variable "web_app_container_cpu" {
  description = "The number of CPU cores for the Web App container."
  type        = number
  default     = 0.5
}

variable "web_app_container_memory" {
  description = "The amount of memory for the Web App container (e.g., 1Gi, 2Gi)."
  type        = string
  default     = "1.0Gi"
}

variable "app_config_endpoint" {
  description = "The endpoint of the App Configuration."
  type        = string
  default     = "$(SHARED_APP_CONFIGURATION_ENDPOINT)"
}

variable "dotnet_env_name" {
  description = "The ASP.NET Core environment name (e.g., Development, Production)."
  type        = string
  default     = "Development"
}

variable "app_config_id" {
  description = "The ID of the App Configuration store."
  type        = string
  default     = "$(SHARED_APP_CONFIGURATION_ID)"
}
variable "sql_admin_login" {
  description = "The administrator login name for the SQL Server."
  type        = string
  default     = "sqladmin"
}

variable "sql_database_name" {
  description = "The name of the SQL Database."
  type        = string
  default     = "sqldb"
}

variable "sql_sku_name" {
  description = "The SKU name for the SQL Database."
  type        = string
  default     = "GP_S_Gen5_1"
}

variable "sql_auto_pause_delay" {
  description = "Time in minutes after which the database is automatically paused."
  type        = number
  default     = 60
}

variable "sql_min_capacity" {
  description = "The minimum capacity of the database in vCores."
  type        = number
  default     = 0.5
}
