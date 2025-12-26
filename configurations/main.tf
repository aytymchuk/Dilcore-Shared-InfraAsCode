# Read the environment-specific configuration files
locals {
  env_lower = lower(var.env_name)
  
  # Configuration files directory (resolves to ./component/environments/env)
  config_dir = "${path.module}/${var.componentName}/environments/${local.env_lower}"
  
  # Distinguish between regular settings and flags
  all_json_files  = fileset(local.config_dir, "*.json")
  flags_file      = "flags.json"
  has_flags       = contains(local.all_json_files, local.flags_file)
  settings_files  = [for f in local.all_json_files : f if f != local.flags_file]

  # Process Regular Settings
  settings_configs = {
    for file in local.settings_files :
    file => jsondecode(file("${local.config_dir}/${file}"))
  }
  merged_settings = merge(values(local.settings_configs)...)

  # Flattening Regular Settings (5 levels) using cleaner 'for...if' approach to avoid type consistency errors
  f1_s = [for k1, v1 in local.merged_settings : {key=k1, val=v1} if !can(tomap(v1)) && !can(toobject(v1))]
  f2_s = flatten([for k1, v1 in local.merged_settings : [for k2, v2 in v1 : {key="${k1}:${k2}", val=v2} if !can(tomap(v2)) && !can(toobject(v2))] if can(tomap(v1)) || can(toobject(v1))])
  f3_s = flatten([for k1, v1 in local.merged_settings : [for k2, v2 in v1 : [for k3, v3 in v2 : {key="${k1}:${k2}:${k3}", val=v3} if !can(tomap(v3)) && !can(toobject(v3))] if can(tomap(v2)) || can(toobject(v2))] if can(tomap(v1)) || can(toobject(v1))])
  f4_s = flatten([for k1, v1 in local.merged_settings : [for k2, v2 in v1 : [for k3, v3 in v2 : [for k4, v4 in v3 : {key="${k1}:${k2}:${k3}:${k4}", val=v4} if !can(tomap(v4)) && !can(toobject(v4))] if can(tomap(v3)) || can(toobject(v3))] if can(tomap(v2)) || can(toobject(v2))] if can(tomap(v1)) || can(toobject(v1))])
  f5_s = flatten([for k1, v1 in local.merged_settings : [for k2, v2 in v1 : [for k3, v3 in v2 : [for k4, v4 in v3 : [for k5, v5 in v4 : {key="${k1}:${k2}:${k3}:${k4}:${k5}", val=v5} if !can(tomap(v5)) && !can(toobject(v5))] if can(tomap(v4)) || can(toobject(v4))] if can(tomap(v3)) || can(toobject(v3))] if can(tomap(v2)) || can(toobject(v2))] if can(tomap(v1)) || can(toobject(v1))])

  regular_configs_list = concat(local.f1_s, local.f2_s, local.f3_s, local.f4_s, local.f5_s)
  regular_configs = {
    for i in local.regular_configs_list :
    i.key => i.val == null ? "" : (can(tostring(i.val)) ? tostring(i.val) : jsonencode(i.val))
  }

  # Process Feature Flags
  flags_config = local.has_flags ? jsondecode(file("${local.config_dir}/${local.flags_file}")) : {}
  
  # Flattening Flags (supports both wrapped and direct structure, 3 levels deep usually enough for flags)
  # Using "_" instead of ":" because Feature Flag names in Azure do not support colons.
  f1_f = [for k1, v1 in local.flags_config : {key=k1, val=v1} if !can(tomap(v1)) && !can(toobject(v1))]
  f2_f = flatten([for k1, v1 in local.flags_config : [for k2, v2 in v1 : {key="${k1}_${k2}", val=v2} if !can(tomap(v2)) && !can(toobject(v2))] if can(tomap(v1)) || can(toobject(v1))])
  f3_f = flatten([for k1, v1 in local.flags_config : [for k2, v2 in v1 : [for k3, v3 in v2 : {key="${k1}_${k2}_${k3}", val=v3} if !can(tomap(v3)) && !can(toobject(v3))] if can(tomap(v2)) || can(toobject(v2))] if can(tomap(v1)) || can(toobject(v1))])

  feature_flags_list = concat(local.f1_f, local.f2_f, local.f3_f)
  feature_flags = {
    for i in local.feature_flags_list :
    i.key => i.val == null ? "" : (can(tostring(i.val)) ? tostring(i.val) : jsonencode(i.val))
  }
}

# Deploy regular configuration keys
resource "azurerm_app_configuration_key" "config" {
  for_each = local.regular_configs

  configuration_store_id = var.app_config_id
  key                    = each.key
  label                  = var.env_name
  value                  = each.value
}

# Deploy feature flags
resource "azurerm_app_configuration_feature" "feature" {
  for_each = local.feature_flags

  configuration_store_id = var.app_config_id
  name                   = each.key
  label                  = var.env_name
  enabled                = lower(each.value) == "true"
  description            = "Feature flag managed by Terraform for ${var.componentName}"
}
