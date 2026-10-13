/*
  Input Variables - Workspace Compute Orchestration Module
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs
*/

# tflint-ignore: terraform_unused_declarations
variable "workspace_url" {
  description = "The target workspace URL passed from the workspace module to establish upstream dependency."
  type        = string
}

variable "admin_group_name" {
  description = "Name of the platform admin group granted management access."
  type        = string
}

variable "user_group_names" {
  description = "List of user group names (e.g. ['dbx-data-engineers']) granted workspace compute access."
  type        = list(string)
  default     = []
}

variable "clusters" {
  description = "Map of all-purpose compute cluster configurations for the workspace."
  type = map(object({
    cluster_name            = string
    spark_version           = string
    node_type_id            = string
    policy_id               = optional(string)
    min_workers             = number
    max_workers             = number
    autotermination_minutes = optional(number, 30)
    custom_tags             = optional(map(string), {})
    user_group_names        = optional(list(string))
  }))
  default = {}
}

variable "sql_warehouses" {
  description = "Map of SQL Warehouse endpoint configurations for the workspace."
  type = map(object({
    name                      = string
    cluster_size              = optional(string, "2X-Small")
    min_num_clusters          = optional(number, 1)
    max_num_clusters          = optional(number, 1)
    auto_stop_mins            = optional(number, 15)
    warehouse_type            = optional(string, "PRO")
    enable_photon             = optional(bool, true)
    enable_serverless_compute = optional(bool, false)
    tags                      = optional(map(string), {})
    user_group_names          = optional(list(string))
  }))
  default = {}
}
