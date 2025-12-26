output "configuration_keys_deployed" {
  description = "Number of configuration keys deployed to App Config"
  value       = length(local.flattened_configs)
}

output "configuration_component" {
  description = "Component name for the deployed configurations"
  value       = var.componentName
}
