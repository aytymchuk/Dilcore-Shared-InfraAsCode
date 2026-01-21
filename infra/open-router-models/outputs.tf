output "ai_core_api_key" {
  value       = openrouter_api_key.ai_core.key
  description = "The generated OpenRouter API key for the AI Core environment"
  sensitive   = true
}
