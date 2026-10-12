/*
  Outputs - All-Purpose Compute Cluster Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "cluster_id" {
  description = "The unique identifier of the Databricks compute cluster."
  value       = databricks_cluster.this.id
}

output "cluster_name" {
  description = "The name of the Databricks compute cluster."
  value       = databricks_cluster.this.cluster_name
}
