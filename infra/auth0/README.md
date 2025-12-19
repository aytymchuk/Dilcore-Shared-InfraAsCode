# Auth0 Infrastructure

This directory contains the Terraform configuration for Auth0 resources.

## Resources Created

- **Resource Server (API)**: The API definition in Auth0.
- **Web App Client**: Regular Web Application client for the main application.
- **API Doc Client**: Regular Web Application client for Swagger/Scalar documentation.

## Variables

The following variables are required (and typically populated via GitHub Secrets or tfvars):

- `auth0_domain`
- `auth0_client_id`
- `auth0_client_secret`
- `env_name`
- `web_app_callbacks`
- `web_app_allowed_logout_urls`
- `web_app_web_origins`
- `api_doc_callbacks`
- `api_doc_allowed_logout_urls`
- `api_doc_web_origins`
