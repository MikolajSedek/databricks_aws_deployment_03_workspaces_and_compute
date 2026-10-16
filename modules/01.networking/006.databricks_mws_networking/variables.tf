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
