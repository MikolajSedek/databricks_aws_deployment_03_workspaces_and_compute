/*
  Outputs - Generic Databricks Workspace Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "workspace_id" {
  description = "The unique numeric identifier of the provisioned Databricks workspace."
  value       = databricks_mws_workspaces.this.workspace_id
}

output "workspace_url" {
  description = "The full HTTPS URL for accessing the provisioned Databricks workspace."
  value       = databricks_mws_workspaces.this.workspace_url
}

output "workspace_status" {
  description = "The current lifecycle status of the Databricks workspace."
  value       = databricks_mws_workspaces.this.workspace_status
}
