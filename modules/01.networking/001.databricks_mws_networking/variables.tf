/*
  Input Variables - Databricks MWS Networking Module
  Documentation:
    - https://docs.databricks.com/aws/en/security/network/classic/privatelink
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/aws-private-link-workspace
    - https://docs.databricks.com/aws/en/admin/cloud-configurations/aws/customer-managed-vpc
*/

variable "databricks_account_id" {
  description = "The Databricks Account ID used for MWS resources."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the Spoke VPC and PrivateLink VPC endpoints reside."
  type        = string
}

variable "network_name" {
  description = "The name of the Databricks MWS network configuration."
  type        = string
}

variable "vpc_id" {
  description = "The AWS VPC ID of the Spoke VPC."
  type        = string

  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "The vpc_id must be a valid AWS VPC ID starting with 'vpc-'."
  }
}

variable "subnet_ids" {
  description = "List of private compute subnet IDs within the Spoke VPC."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for Databricks compute clusters."
  type        = list(string)
}

variable "workspace_vpce_id" {
  description = "The AWS VPC Endpoint ID (vpce-*) for the Databricks Workspace (REST API) PrivateLink endpoint."
  type        = string

  validation {
    condition     = startswith(var.workspace_vpce_id, "vpce-")
    error_message = "The workspace_vpce_id must be a valid AWS VPC Endpoint ID starting with 'vpce-'."
  }
}

variable "relay_vpce_id" {
  description = "The AWS VPC Endpoint ID (vpce-*) for the Databricks Secure Cluster Connectivity (SCC) Relay PrivateLink endpoint."
  type        = string

  validation {
    condition     = startswith(var.relay_vpce_id, "vpce-")
    error_message = "The relay_vpce_id must be a valid AWS VPC Endpoint ID starting with 'vpce-'."
  }
}

variable "public_access_enabled" {
  description = "Whether public internet access to the workspace web console is allowed alongside PrivateLink."
  type        = bool
  default     = true
}

variable "private_access_level" {
  description = "Private access level for Databricks Private Access Settings (ACCOUNT or ENDPOINT)."
  type        = string
  default     = "ACCOUNT"

  validation {
    condition     = contains(["ACCOUNT", "ENDPOINT"], var.private_access_level)
    error_message = "The private_access_level must be either 'ACCOUNT' or 'ENDPOINT'."
  }
}
