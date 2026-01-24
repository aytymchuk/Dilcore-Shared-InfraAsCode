# General Settings
dotnet_env_name = "Development"

# Tags
tags = {
  "CreatedBy"   = "Terraform"
  "Environment" = "Development"
  "Kind"        = "Platform"
}

# Platform API
api_name             = "api"
api_container_cpu    = 0.5
api_container_memory = "1.0Gi"

# AI Core
ai_core_name             = "ai-core"
ai_core_container_cpu    = 0.5
ai_core_container_memory = "1.0Gi"

# Web App
web_app_name             = "web-app"
web_app_container_cpu    = 0.5
web_app_container_memory = "1.0Gi"
