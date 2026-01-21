terraform {
  required_providers {
    openrouter = {
      source  = "mcmarkj/openrouter"
      version = "~> 0.0.1"
    }
  }
}

provider "openrouter" {
  api_key = "$(OPEN_ROUTER_API_KEY)"
}
