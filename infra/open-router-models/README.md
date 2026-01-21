# OpenRouter Models Infrastructure

This module manages OpenRouter API keys and credit limits for the Dilcore AI Core project.

## Resources

- **`openrouter_api_key`**: Manages the API key used by the AI Core to interact with OpenRouter models.

## Variables

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `ai_core_limit` | `number` | The monthly credit limit for the AI Core API key in USD | `5` |
| `env_name` | `string` | The name of the environment (e.g., Development, QA, Staging, Production) | n/a |
| `region` | `string` | Azure region (required by pipeline template but not used by this module) | n/a |
| `componentName` | `string` | Component name (required by pipeline template) | n/a |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---:|
| `ai_core_api_key` | The generated OpenRouter API key for the AI Core environment | Yes |

## Usage

This module is typically used in conjunction with the Platform API to provide access to AI models. The generated API key should be stored in Azure App Configuration for the API to use.

```hcl
module "open_router" {
  source = "../open-router-models"

  env_name      = var.env_name
  ai_core_limit = 10
  # ... other variables
}
```
