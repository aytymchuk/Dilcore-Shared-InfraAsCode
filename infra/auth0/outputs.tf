# API Outputs
output "api_audience" {
  description = "The audience (identifier) of the Auth0 API."
  value       = auth0_resource_server.api.identifier
}

output "api_domain" {
  description = "The Auth0 domain."
  value       = var.auth0_domain
}

output "api_id" {
  description = "The ID of the Auth0 API."
  value       = auth0_resource_server.api.id
}

# Web App Outputs
output "web_app_client_id" {
  description = "The Client ID of the Web App."
  value       = auth0_client.web_app.client_id
}

output "web_app_client_secret" {
  description = "The Client Secret of the Web App."
  value       = auth0_client_credentials.web_app_credentials.client_secret
  sensitive   = true
}

# API Doc Outputs
output "api_doc_client_id" {
  description = "The Client ID of the API Doc client."
  value       = auth0_client.api_doc.client_id
}

output "api_doc_client_secret" {
  description = "The Client Secret of the API Doc client."
  value       = auth0_client_credentials.api_doc_credentials.client_secret
  sensitive   = true
}
