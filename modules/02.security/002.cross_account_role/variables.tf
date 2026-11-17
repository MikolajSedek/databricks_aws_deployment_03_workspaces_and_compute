/*
  Input Variables - Databricks Cross-Account IAM Role Module
  Documentation:
    - https://docs.databricks.com/aws/en/admin/account-settings/manage-credentials
    - https://docs.databricks.com/aws/en/admin/cloud-configurations/aws/iam-role
*/

variable "role_name" {
  description = "The name of the AWS IAM cross-account role for Databricks."
  type        = string
}

variable "databricks_account_id" {
  description = "The Databricks Account ID used as the External ID in the trust policy."
  type        = string
}

variable "credentials_name" {
  description = "The name of the Databricks MWS credentials configuration."
  type        = string
}

variable "tags" {
  description = "Map of resource tags to attach to the IAM role."
  type        = map(string)
  default     = {}
}
