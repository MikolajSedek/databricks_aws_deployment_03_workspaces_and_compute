/*
  Input Variables - Generic Databricks Workspace Module
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment
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
  description = "The Databricks MWS Private Access Settings ID."
  type        = string
}

variable "pricing_tier" {
  description = "The pricing tier of the workspace (e.g. PREMIUM, ENTERPRISE)."
  type        = string
  default     = "ENTERPRISE"
}

variable "admin_principal_id" {
  description = "The principal ID of the platform administrators group (assigned ADMIN permissions)."
  type        = string
}

variable "persona_principal_id" {
  description = "The principal ID of the persona group (assigned USER permissions)."
  type        = string
  default     = null
}
