dotnet_env_name = "Development"

tags = {
  "CreatedBy"   = "Terraform"
  "Environment" = "Development"
  "Kind"        = "Platform"
}

container_cpu    = 0.5
container_memory = "1.0Gi"

api_name             = "api"
sql_database_name    = "sqldb"
sql_admin_login      = "sqladmin"
sql_sku_name         = "GP_S_Gen5_1"
sql_min_capacity     = 0.5
sql_auto_pause_delay = 60
