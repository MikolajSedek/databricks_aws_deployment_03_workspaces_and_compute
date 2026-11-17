/*
  Outputs - Databricks Cross-Account IAM Role Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "credentials_id" {
  description = "The unique identifier of the registered Databricks MWS credentials."
  value       = databricks_mws_credentials.this.credentials_id
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the provisioned AWS IAM cross-account role."
  value       = aws_iam_role.cross_account_role.arn
}
