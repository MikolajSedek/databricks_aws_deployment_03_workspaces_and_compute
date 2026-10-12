/*
  Outputs Definition - Dev Environment
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs

  Exports non-redundant, essential operational endpoints and identifiers:
    - Workspace URLs for developer access.
    - Workspace IDs for API and automation orchestration.
    - Cross-account IAM role ARN and MWS network ID.
*/

output "workspace_urls" {
  description = "Map of workspace keys to their access URLs."
  value = {
    for k, v in module.workspaces : k => v.workspace_url
  }
}

output "workspace_ids" {
  description = "Map of workspace keys to their numeric Databricks workspace IDs."
  value = {
    for k, v in module.workspaces : k => v.workspace_id
  }
}

output "cross_account_role_arn" {
  description = "The ARN of the AWS IAM cross-account role assumed by Databricks."
  value       = module.cross_account_role.role_arn
}

output "mws_network_id" {
  description = "The unique identifier of the registered Databricks MWS network configuration."
  value       = module.mws_networking.network_id
}

output "backend_bucket_name" {
  description = "The S3 bucket name used for remote state storage."
  value       = module.backend_bucket.bucket_name
}
