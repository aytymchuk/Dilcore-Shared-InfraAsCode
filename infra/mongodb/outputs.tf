output "cluster_name" {
  value = mongodbatlas_advanced_cluster.atlas_cluster.name
}

output "project_name" {
  value = mongodbatlas_project.atlas_project.name
}
