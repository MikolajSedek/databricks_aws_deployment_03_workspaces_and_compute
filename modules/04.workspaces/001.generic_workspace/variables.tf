/*
  Input Variables - Generic Databricks Workspace Module
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/aws-private-link-workspace
*/

variable "account_id" {
  description = "The Databricks Account ID."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the workspace will reside."
  type        = string
}

variable "workspace_name" {
  description = "The name of the Databricks workspace to create."
  type        = string
}

variable "credentials_id" {
  description = "The Databricks MWS credentials ID (cross-account IAM role)."
  type        = string
}

variable "storage_configuration_id" {
  description = "The Databricks MWS storage configuration ID (root S3 bucket)."
  type        = string
}

variable "network_id" {
  description = "The Databricks MWS network ID (customer-managed VPC)."
  type        = string
}

variable "storage_customer_managed_key_id" {
  description = "The Databricks MWS customer-managed key ID for storage encryption."
  type        = string
}

variable "private_access_settings_id" {
  description = "The Databricks MWS Private Access Settings (PAS) ID for PrivateLink connectivity."
  type        = string
  default     = null
}

variable "pricing_tier" {
  description = "The pricing tier of the workspace (e.g. PREMIUM, ENTERPRISE)."
  type        = string
  default     = "ENTERPRISE"
}

variable "admin_group_name" {
  description = "The name of the platform administrator group (e.g. dbx-platform-admins)."
  type        = string
  default     = null
}

variable "user_group_names" {
  description = "List of user group names (e.g. ['dbx-data-engineers']) granted USER role on the workspace."
  type        = list(string)
  default     = []
}

variable "admin_principal_id" {
  description = "Deprecated principal ID of the platform administrators group."
  type        = string
  default     = null
}

variable "persona_principal_id" {
  description = "Deprecated principal ID of the persona group."
  type        = string
  default     = null
}
