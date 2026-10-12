/*
  Outputs - Workspace Compute Orchestration Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "policy_ids" {
  description = "Map of compute cluster policy keys to their policy IDs."
  value       = module.compute_policies.policy_ids
}

output "cluster_ids" {
  description = "Map of cluster configuration keys to their created cluster IDs."
  value = {
    for k, v in module.clusters : k => v.cluster_id
  }
}

output "sql_warehouse_ids" {
  description = "Map of SQL Warehouse configuration keys to their endpoint IDs."
  value = {
    for k, v in module.sql_warehouses : k => v.endpoint_id
  }
}

output "sql_warehouse_jdbc_urls" {
  description = "Map of SQL Warehouse configuration keys to their JDBC URLs."
  value = {
    for k, v in module.sql_warehouses : k => v.jdbc_url
  }
}
