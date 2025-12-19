locals {
  api_identifier = var.api_identifier != "" ? var.api_identifier : "https://api.${var.env_name}.dilcore.com"
}

resource "auth0_resource_server" "api" {
  name        = "Dilcore API ${var.env_name}"
  identifier  = local.api_identifier
  signing_alg = "RS256"

  allow_offline_access                            = true
  token_lifetime                                  = 86400
  skip_consent_for_verifiable_first_party_clients = true
}

resource "auth0_client" "web_app" {
  name        = "Dilcore Web App ${var.env_name}"
  description = "Web Application Client for ${var.env_name}"
  app_type    = "regular_web"
  
  callbacks           = var.web_app_callbacks
  allowed_logout_urls = var.web_app_allowed_logout_urls
  web_origins         = var.web_app_web_origins
  
  oidc_conformant = true

  jwt_configuration {
    alg = "RS256"
  }
}

resource "auth0_client_credentials" "api_doc_credentials" {
  client_id = auth0_client.api_doc.id
  authentication_method = "client_secret_post"
}

resource "auth0_client_credentials" "web_app_credentials" {
  client_id = auth0_client.web_app.id
  authentication_method = "client_secret_post"
}

resource "auth0_client" "api_doc" {
  name        = "Dilcore API Docs ${var.env_name}"
  description = "API Documentation Client for ${var.env_name}"
  app_type    = "regular_web"
  
  callbacks           = var.api_doc_callbacks
  allowed_logout_urls = var.api_doc_allowed_logout_urls
  web_origins         = var.api_doc_web_origins
  
  oidc_conformant = true
  
  jwt_configuration {
    alg = "RS256"
  }
}
