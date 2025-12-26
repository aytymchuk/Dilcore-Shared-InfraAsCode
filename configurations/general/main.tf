# Data source to get the App Configuration store
data "azurerm_app_configuration" "main" {
  name                = var.app_config_name
  resource_group_name = var.app_config_resource_group
}

# Read the environment-specific configuration files
locals {
  env_lower = lower(var.env_name)
  
  # Configuration files directory
  config_dir = "${path.module}/environments/${local.env_lower}"
  
  # Find all JSON files in the environment directory
  json_files = fileset(local.config_dir, "*.json")
  
  # Read and parse all JSON files
  json_configs = {
    for file in local.json_files :
    file => jsondecode(file("${local.config_dir}/${file}"))
  }
  
  # Merge all configs into a single object
  merged_config = merge(values(local.json_configs)...)
  
  # Flatten the nested JSON structure to colon-separated keys
  # Level 1: Root keys
  flattened_level_1 = flatten([
    for k1, v1 in local.merged_config : [
      can(tomap(v1)) || can(toobject(v1)) ? [] : [{
        key   = k1
        value = tostring(v1)
      }]
    ]
  ])
  
  # Level 2: One level deep
  flattened_level_2 = flatten([
    for k1, v1 in local.merged_config : [
      can(tomap(v1)) || can(toobject(v1)) ? [
        for k2, v2 in v1 : 
          can(tomap(v2)) || can(toobject(v2)) ? [] : {
            key   = "${k1}:${k2}"
            value = tostring(v2)
          }
      ] : []
    ]
  ])
  
  # Level 3: Two levels deep
  flattened_level_3 = flatten([
    for k1, v1 in local.merged_config : [
      can(tomap(v1)) || can(toobject(v1)) ? [
        for k2, v2 in v1 : 
          can(tomap(v2)) || can(toobject(v2)) ? [
            for k3, v3 in v2 :
              can(tomap(v3)) || can(toobject(v3)) ? [] : {
                key   = "${k1}:${k2}:${k3}"
                value = tostring(v3)
              }
          ] : []
      ] : []
    ]
  ])
  
  # Level 4: Three levels deep
  flattened_level_4 = flatten([
    for k1, v1 in local.merged_config : [
      can(tomap(v1)) || can(toobject(v1)) ? [
        for k2, v2 in v1 : 
          can(tomap(v2)) || can(toobject(v2)) ? [
            for k3, v3 in v2 :
              can(tomap(v3)) || can(toobject(v3)) ? [
                for k4, v4 in v3 :
                  can(tomap(v4)) || can(toobject(v4)) ? [] : {
                    key   = "${k1}:${k2}:${k3}:${k4}"
                    value = tostring(v4)
                  }
              ] : []
          ] : []
      ] : []
    ]
  ])
  
  # Level 5: Four levels deep
  flattened_level_5 = flatten([
    for k1, v1 in local.merged_config : [
      can(tomap(v1)) || can(toobject(v1)) ? [
        for k2, v2 in v1 : 
          can(tomap(v2)) || can(toobject(v2)) ? [
            for k3, v3 in v2 :
              can(tomap(v3)) || can(toobject(v3)) ? [
                for k4, v4 in v3 :
                  can(tomap(v4)) || can(toobject(v4)) ? [
                    for k5, v5 in v4 : {
                      key   = "${k1}:${k2}:${k3}:${k4}:${k5}"
                      value = tostring(v5)
                    }
                  ] : []
              ] : []
          ] : []
      ] : []
    ]
  ])
  
  # Combine all levels
  all_flattened = concat(
    local.flattened_level_1,
    local.flattened_level_2,
    local.flattened_level_3,
    local.flattened_level_4,
    local.flattened_level_5
  )
  
  # Convert to map
  flattened_configs = {
    for item in local.all_flattened :
    item.key => item.value
  }
}

# Deploy configuration keys to Azure App Configuration
resource "azurerm_app_configuration_key" "config" {
  for_each = local.flattened_configs

  configuration_store_id = data.azurerm_app_configuration.main.id
  key                    = each.key
  label                  = var.env_name
  value                  = each.value
}
