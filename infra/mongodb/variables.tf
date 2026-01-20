# MongoDB Atlas API Keys
variable "mongodbatlas_public_key" {
  description = "MongoDB Atlas Public Key"
  type        = string
  sensitive   = true
  default     = "$(MONGO_PUBLIC_KEY)"
}

variable "mongodbatlas_private_key" {
  description = "MongoDB Atlas Private Key"
  type        = string
  sensitive   = true
  default     = "$(MONGO_API_KEY)"
}

# Organization and Project Configuration
variable "org_id" {
  description = "MongoDB Atlas Organization ID"
  type        = string
  default     = "$(MONGO_ORG_ID)"
}

#Common Variables

variable "componentName" {
  description = "The name of the component. Populated in the pipeline."
  default     = "shared"
  type        = string
  validation {
    condition     = length(var.componentName) >= 3
    error_message = "The componentName must be at least 3 characters long."
  }
}

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

# Project Variables

variable "project_teams" {
  description = "List of teams to add to the project"
  type = list(object({
    team_id    = string
    role_names = list(string)
  }))
  default = []
}

variable "project_tags" {
  description = "Tags to apply to the MongoDB Atlas project - following MCP tagging standards"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "Dilcore"
    ManagedBy   = "Terraform"
    Owner       = "DevTeam"
  }

  validation {
    condition = alltrue([
      for k, v in var.project_tags : length(k) <= 512 && length(v) <= 256
    ])
    error_message = "Tag names must be 512 characters or less, and tag values must be 256 characters or less."
  }
}

variable "cluster_tags" {
  description = "Tags to apply to the MongoDB Atlas cluster - following MCP tagging standards"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.cluster_tags : length(k) <= 512 && length(v) <= 256
    ])
    error_message = "Tag names must be 512 characters or less, and tag values must be 256 characters or less."
  }
}

# Network Access Configuration
variable "ip_access_list_cidr" {
  description = "CIDR block for IP access list"
  type        = string
  default     = "0.0.0.0/0"
}

variable "additional_ip_addresses" {
  description = "Additional IP addresses to allow access"
  type        = list(string)
  default     = []
}

# Azure App Configuration
variable "app_config_id" {
  description = "Azure App Configuration resource ID"
  type        = string
  default     = "$(SHARED_APP_CONFIGURATION_ID)"
}

# Atlas Region Mapping for Azure (M0 supported regions only)
variable "atlas_region_mapping" {
  description = "Mapping of Azure regions to Atlas regions that support M0 clusters"
  type        = map(string)
  default = {
    # North America - M0 Supported
    "eastus2" = "US_EAST_2"
    "westus"  = "US_WEST"

    # Europe - M0 Supported
    "westeurope" = "EUROPE_WEST"

    # Asia - M0 Supported
    "eastasia"      = "ASIA_EAST"
    "southeastasia" = "ASIA_SOUTH_EAST"
  }
}

# MongoDB Atlas Cluster Configuration Variables
variable "instance_size" {
  description = "MongoDB Atlas cluster instance size"
  type        = string
  default     = "M0"

  validation {
    condition     = contains(["M0", "M2", "M5", "M10", "M20", "M30", "M40", "M50", "M60", "M80", "M100", "M140", "M200", "M300"], var.instance_size)
    error_message = "Instance size must be a valid MongoDB Atlas cluster tier."
  }
}

variable "cluster_provider_name" {
  description = "MongoDB Atlas cluster provider name"
  type        = string
  default     = "TENANT"

  validation {
    condition     = contains(["AWS", "GCP", "AZURE", "TENANT"], var.cluster_provider_name)
    error_message = "Provider name must be one of: AWS, GCP, AZURE, TENANT."
  }
}

variable "backing_provider_name" {
  description = "MongoDB Atlas backing provider name (for M0 clusters)"
  type        = string
  default     = "AZURE"

  validation {
    condition     = contains(["AWS", "GCP", "AZURE"], var.backing_provider_name)
    error_message = "Backing provider name must be one of: AWS, GCP, AZURE."
  }
}

variable "cluster_priority" {
  description = "MongoDB Atlas cluster priority"
  type        = number
  default     = 7

  validation {
    condition     = var.cluster_priority >= 0 && var.cluster_priority <= 7
    error_message = "Cluster priority must be between 0 and 7."
  }
}
