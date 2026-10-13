/*
  Outputs - Databricks Compute Policies Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "shared_policy_id" {
  description = "The shared cluster policy ID governing workspace compute clusters."
  value       = databricks_cluster_policy.shared_policy.id
}
