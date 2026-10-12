/*
  Outputs - Databricks Compute Policies Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "policy_ids" {
  description = "Map of compute cluster policy keys to their created policy IDs."
  value = {
    admin           = databricks_cluster_policy.admin_policy.id
    data_engineers  = databricks_cluster_policy.data_engineers.id
    data_scientists = databricks_cluster_policy.data_scientists.id
    data_analysts   = databricks_cluster_policy.data_analysts.id
  }
}
