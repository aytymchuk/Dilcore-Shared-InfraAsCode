variable "auth0_domain" {
  description = "The Auth0 domain."
  type        = string
  default     = "$(AUTH0_DOMAIN)"
}

variable "auth0_client_id" {
  description = "The Auth0 Client ID for the Terraform provider."
  type        = string
  sensitive   = true
  default     = "$(AUTH0_CLIENT_ID)"
}

variable "auth0_client_secret" {
  description = "The Auth0 Client Secret for the Terraform provider."
  type        = string
  sensitive   = true
  default     = "$(AUTH0_CLIENT_SECRET)"
}

variable "env_name" {
  description = "The environment name (e.g., development, qa, production)."
  type        = string
}

variable "web_app_callbacks" {
  description = "List of allowed callback URLs for the Web App."
  type        = list(string)
  default     = []
}

variable "web_app_allowed_logout_urls" {
  description = "List of allowed logout URLs for the Web App."
  type        = list(string)
  default     = []
}

variable "web_app_web_origins" {
  description = "List of allowed web origins for the Web App."
  type        = list(string)
  default     = []
}

variable "api_doc_callbacks" {
  description = "List of allowed callback URLs for the API Doc client."
  type        = list(string)
  default     = []
}

variable "api_doc_allowed_logout_urls" {
  description = "List of allowed logout URLs for the API Doc client."
  type        = list(string)
  default     = []
}

variable "api_doc_web_origins" {
  description = "List of allowed web origins for the API Doc client."
  type        = list(string)
  default     = []
}

variable "api_identifier" {
  description = "The identifier for the API."
  type        = string
  default     = "" # If empty, will be generated based on env_name
}

variable "region" {
  description = "The region (e.g. us-east-1). Passed by common CI/CD scripts but unused in this module."
  type        = string
  default     = ""
}

variable "componentName" {
  description = "The component name. Passed by common CI/CD scripts but unused in this module."
  type        = string
  default     = ""
}
