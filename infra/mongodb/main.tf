# Generate random username for database user
resource "random_string" "db_username" {
  length  = 8
  special = false
  upper   = false
}

# Generate random password for database user
resource "random_password" "db_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}

locals {
  project_name = "${lower(var.env_name)}-${lower(var.componentName)}"
  cluster_name = "${lower(var.env_name)}-${lower(var.componentName)}-${lower(var.region)}"
  db_username = random_string.db_username.result
  db_password = random_password.db_password.result
}

# Create a Project
resource "mongodbatlas_project" "atlas_project" {
  name   = local.project_name
  org_id = var.org_id

  # Optional: Add project teams
  dynamic "teams" {
    for_each = var.project_teams
    content {
      team_id    = teams.value.team_id
      role_names = teams.value.role_names
    }
  }

  tags = var.project_tags
}

# Create M0 Cluster (Free Tier) using Advanced Cluster Resource
resource "mongodbatlas_advanced_cluster" "atlas_cluster" {
  project_id   = mongodbatlas_project.atlas_project.id
  name         = local.cluster_name
  cluster_type = "REPLICASET"

  # Replication Specs for M0 (Free Tier)
  replication_specs = [
    {
      num_shards = 1
      region_configs = [
        {
          electable_specs = {
            instance_size = var.instance_size
          }
          provider_name         = var.cluster_provider_name
          backing_provider_name = var.backing_provider_name
          priority              = var.cluster_priority
          region_name           = lookup(var.atlas_region_mapping, var.region, var.region)
        }
      ]
    }
  ]

  # MCP Compliant Tags for Cluster
  tags = var.cluster_tags
}

# Create Database User
resource "mongodbatlas_database_user" "atlas_db_user" {
  username           = local.db_username
  password           = local.db_password
  project_id         = mongodbatlas_project.atlas_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "admin"
  }

  labels {
    key   = "environment"
    value = var.env_name
  }
}

# Create IP Access List Entry
resource "mongodbatlas_project_ip_access_list" "ip_access_list" {
  project_id = mongodbatlas_project.atlas_project.id

  # Allow access from anywhere (0.0.0.0/0) - adjust as needed for security
  cidr_block = var.ip_access_list_cidr
  comment    = "Access from ${var.env_name} environment"
}

# Optional: Create additional IP access entries
resource "mongodbatlas_project_ip_access_list" "additional_ips" {
  for_each = toset(var.additional_ip_addresses)

  project_id = mongodbatlas_project.atlas_project.id
  ip_address = each.value
  comment    = "Additional IP access for ${var.env_name}"
}

# Wait for cluster to be ready
resource "null_resource" "cluster_ready" {
  depends_on = [mongodbatlas_advanced_cluster.atlas_cluster]
  
  triggers = {
    cluster_id = mongodbatlas_advanced_cluster.atlas_cluster.cluster_id
  }
}

# Add MongoDB connection string to Azure App Configuration
resource "azurerm_app_configuration_key" "mongodb_connection_string" {
  configuration_store_id = var.app_config_id
  key                   = "General:MongoDbSettings:ConnectionString"
  value                 = replace(mongodbatlas_advanced_cluster.atlas_cluster.connection_strings.standard_srv, 
                                  "mongodb+srv://", "mongodb+srv://${mongodbatlas_database_user.atlas_db_user.username}:${mongodbatlas_database_user.atlas_db_user.password}@")
  content_type          = "text/plain" 
  
  depends_on = [
    mongodbatlas_advanced_cluster.atlas_cluster,
    null_resource.cluster_ready
  ]

  tags = {
    Environment = var.env_name
    ManagedBy   = "Terraform"
    Service     = "MongoDB"
  }
}