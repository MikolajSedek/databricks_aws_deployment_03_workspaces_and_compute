/*
  Input Variables - All-Purpose Compute Cluster Module
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster
*/

variable "cluster_name" {
  description = "The name of the Databricks all-purpose cluster."
  type        = string
}

variable "spark_version" {
  description = "The Databricks Runtime (DBR) version string (e.g. 15.4.x-scala2.12)."
  type        = string
}

variable "node_type_id" {
  description = "The AWS EC2 instance type ID for worker and driver nodes."
  type        = string
}

variable "policy_id" {
  description = "The Databricks cluster policy ID enforcing sizing and governance."
  type        = string
}

variable "autotermination_minutes" {
  description = "Auto-termination timeout in minutes when the cluster is idle."
  type        = number
  default     = 30
}

variable "min_workers" {
  description = "Minimum number of worker nodes for autoscaling."
  type        = number
  default     = 1
}

variable "max_workers" {
  description = "Maximum number of worker nodes for autoscaling."
  type        = number
  default     = 3
}

variable "admin_group_name" {
  description = "Single platform admin group name granted CAN_MANAGE permission."
  type        = string
}

variable "user_group_names" {
  description = "List of group names granted CAN_RESTART and CAN_ATTACH_TO permissions."
  type        = list(string)
  default     = []
}

variable "custom_tags" {
  description = "Additional tags to attach to the cluster."
  type        = map(string)
  default     = {}
}
