variable "env_name" {
  description = "The name of the environment (e.g., Development, QA, Staging, Production). Populated in the pipeline."
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
  type        = string
  validation {
    condition     = length(var.componentName) >= 3
    error_message = "The componentName must be at least 3 characters long."
  }
}

variable "app_config_id" {
  description = "The ID of the Azure App Configuration store."
  type        = string
  default     = "$(SHARED_APP_CONFIGURATION_ID)"
}

variable "app_config_resource_group" {
  description = "The resource group name of the Azure App Configuration store."
  type        = string
  default     = "$(SHARED_RESOURCEGROUPNAME)"
}
