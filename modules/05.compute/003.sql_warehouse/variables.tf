/*
  Input Variables - Databricks SQL Warehouse Module
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint
*/

variable "name" {
  description = "The name of the Databricks SQL Warehouse endpoint."
  type        = string
}

variable "cluster_size" {
  description = "The size of the SQL Warehouse cluster (e.g. 2X-Small, X-Small, Small, Medium)."
  type        = string
  default     = "2X-Small"
}

variable "min_num_clusters" {
  description = "Minimum number of clusters available for query processing."
  type        = number
  default     = 1
}

variable "max_num_clusters" {
  description = "Maximum number of clusters available for query processing."
  type        = number
  default     = 1
}

variable "auto_stop_mins" {
  description = "Time in minutes of inactivity before the warehouse automatically stops."
  type        = number
  default     = 15
}

variable "warehouse_type" {
  description = "The type of warehouse: CLASSIC or PRO."
  type        = string
  default     = "PRO"
}

variable "enable_serverless_compute" {
  description = "Whether serverless compute is enabled for this SQL Warehouse."
  type        = bool
  default     = false
}

variable "admin_group_name" {
  description = "Group name granted CAN_MANAGE permission."
  type        = string
}

variable "user_group_name" {
  description = "Group name granted CAN_USE permission."
  type        = string
  default     = null
}

variable "tags" {
  description = "Custom key-value tags to apply to the SQL warehouse."
  type        = map(string)
  default     = {}
}
