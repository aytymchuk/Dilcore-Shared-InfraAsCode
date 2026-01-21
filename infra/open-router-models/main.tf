resource "openrouter_api_key" "ai_core" {
  name  = "ai-core-${lower(var.env_name)}"
  limit = var.ai_core_limit
}
