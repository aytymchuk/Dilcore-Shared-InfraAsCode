variable "ai_core_limit" {
  type        = number
  description = "The monthly credit limit for the AI Core API key in USD"
  default     = 5
}

variable "env_name" {
  type        = string
  description = "The name of the environment (e.g., Development, QA, Staging, Production)"
}

variable "region" {
  type        = string
  description = "Azure region (required by pipeline template but not used by this module)"
}

variable "componentName" {
  type        = string
  description = "Component name (required by pipeline template)"
}
