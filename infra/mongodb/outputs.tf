output "cluster_name" {
  description = "The name of the MongoDB Atlas cluster"
  value       = mongodbatlas_advanced_cluster.atlas_cluster.name
}

output "project_name" {
  description = "The name of the MongoDB Atlas project"
  value       = mongodbatlas_project.atlas_project.name
}
