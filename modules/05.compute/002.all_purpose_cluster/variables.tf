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

variable "runtime_engine" {
  description = "The runtime engine type: 'STANDARD' or 'PHOTON'. Defaults to 'STANDARD' to explicitly disable Photon."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "PHOTON"], var.runtime_engine)
    error_message = "The runtime_engine must be either 'STANDARD' or 'PHOTON'."
  }
}

variable "data_security_mode" {
  description = "The data security mode / access mode for Unity Catalog (e.g. 'USER_ISOLATION', 'SINGLE_USER'). Defaults to 'USER_ISOLATION' to prevent NO_ISOLATION errors in modern workspaces."
  type        = string
  default     = "USER_ISOLATION"

  validation {
    condition     = contains(["USER_ISOLATION", "SINGLE_USER"], var.data_security_mode)
    error_message = "The data_security_mode must be either 'USER_ISOLATION' or 'SINGLE_USER'. 'NO_ISOLATION' or legacy modes are not allowed."
  }
}

variable "single_user_name" {
  description = "The username or service principal client ID for single-user clusters when data_security_mode is 'SINGLE_USER'."
  type        = string
  default     = null
}

variable "enable_elastic_disk" {
  description = "Whether autoscaling local storage (elastic disk) is enabled for worker nodes to dynamically attach additional EBS storage as needed."
  type        = bool
  default     = true
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
