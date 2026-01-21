terraform {
  required_providers {
    openrouter = {
      source  = "standujar/openrouter"
      version = "~> 0.1.0"
    }
  }
}

provider "openrouter" {
  api_key = "$(OPEN_ROUTER_API_KEY)"
}
