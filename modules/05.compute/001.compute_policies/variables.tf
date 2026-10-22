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

variable "user_group_names" {
  description = "List of user group names granted CAN_USE permission on the shared policy."
  type        = list(string)
  default     = []
}
