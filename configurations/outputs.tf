output "configuration_keys_deployed" {
  description = "Number of configuration keys deployed to App Config"
  value       = length(local.regular_configs)
}

output "configuration_component" {
  description = "Component name for the deployed configurations"
  value       = var.componentName
}

output "feature_flags_deployed" {
  description = "Number of feature flags deployed to App Config"
  value       = length(local.feature_flags)
}
