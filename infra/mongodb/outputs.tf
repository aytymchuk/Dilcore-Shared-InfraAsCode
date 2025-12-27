output "cluster_name" {
  description = "The name of the MongoDB Atlas cluster"
  value       = mongodbatlas_advanced_cluster.atlas_cluster.name
}

output "project_name" {
  description = "The name of the MongoDB Atlas project"
  value       = mongodbatlas_project.atlas_project.name
}
output "mongodb_connection_string" {
  description = "The MongoDB connection string with credentials"
  value       = "${replace(mongodbatlas_advanced_cluster.atlas_cluster.connection_strings.standard_srv, "mongodb+srv://", "mongodb+srv://${mongodbatlas_database_user.atlas_db_user.username}:${mongodbatlas_database_user.atlas_db_user.password}@")}/${var.app_database_name}"
  sensitive   = true
}
