/*
  Input Variables - Databricks Compute Policies Module
  Documentation:
    - https://docs.databricks.com/aws/en/admin/clusters/policies
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy
*/

variable "admin_group_name" {
  description = "The workspace group name for platform administrators (e.g. dbx-platform-admins)."
  type        = string
}

variable "data_engineers_group_name" {
  description = "The workspace group name for data engineers (e.g. dbx-data-engineers)."
  type        = string
  default     = null
}

variable "data_scientists_group_name" {
  description = "The workspace group name for data scientists (e.g. dbx-data-scientists)."
  type        = string
  default     = null
}

variable "data_analysts_group_name" {
  description = "The workspace group name for data analysts (e.g. dbx-data-analysts)."
  type        = string
  default     = null
}
