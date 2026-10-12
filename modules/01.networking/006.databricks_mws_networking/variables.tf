/*
  Input Variables - Databricks MWS Networking Module
  Documentation:
    - https://docs.databricks.com/aws/en/security/network/classic/privatelink
    - https://docs.databricks.com/aws/en/admin/cloud-configurations/aws/customer-managed-vpc
    - https://docs.databricks.com/en/resources/supported-regions.html
*/

variable "databricks_account_id" {
  description = "The Databricks Account ID used for MWS resources."
  type        = string
}

variable "network_name" {
  description = "The name of the Databricks MWS network configuration."
  type        = string
}

variable "vpc_id" {
  description = "The AWS VPC ID of the Spoke VPC."
  type        = string
}

variable "subnet_ids" {
  description = "List of private compute subnet IDs within the Spoke VPC."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for Databricks compute clusters."
  type        = list(string)
}

variable "aws_region" {
  description = "The AWS region where networking resources are deployed."
  type        = string
  default     = "eu-central-1"
}

variable "workspace_vpce_service_name" {
  description = "The AWS VPC Endpoint service name for Databricks Workspace REST API (eu-central-1)."
  type        = string
  default     = "com.amazonaws.vpce.eu-central-1.vpce-svc-081f78503812597f7"
}

variable "relay_vpce_service_name" {
  description = "The AWS VPC Endpoint service name for Databricks SCC Relay (eu-central-1)."
  type        = string
  default     = "com.amazonaws.vpce.eu-central-1.vpce-svc-08e5dfca9572c85c4"
}

variable "public_access_enabled" {
  description = "Whether public internet access to the workspace web console is allowed (recommended true for dev)."
  type        = bool
  default     = true
}

variable "private_access_level" {
  description = "Private access level for PAS (ACCOUNT or ENDPOINT)."
  type        = string
  default     = "ACCOUNT"

  validation {
    condition     = contains(["ACCOUNT", "ENDPOINT"], var.private_access_level)
    error_message = "private_access_level must be either 'ACCOUNT' or 'ENDPOINT'."
  }
}

variable "tags" {
  description = "Map of resource tags to assign to AWS networking resources."
  type        = map(string)
  default     = {}
}
