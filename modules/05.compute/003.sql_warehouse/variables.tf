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
  description = "The type of warehouse: only 'PRO' is supported (CLASSIC is not permitted)."
  type        = string
  default     = "PRO"

  validation {
    condition     = var.warehouse_type == "PRO"
    error_message = "Only 'PRO' warehouse type is supported. CLASSIC is not permitted."
  }
}

variable "enable_photon" {
  description = "Whether Photon engine acceleration is enabled. Must be true for PRO and Serverless SQL warehouses."
  type        = bool
  default     = true

  validation {
    condition     = var.enable_photon == true
    error_message = "Photon engine acceleration must be enabled (enable_photon = true)."
  }
}

variable "enable_serverless_compute" {
  description = "Whether serverless compute is enabled for this SQL Warehouse. Set to true to transition to Serverless SQL once workspace serverless compute prerequisites and terms are enabled."
  type        = bool
  default     = false
}

variable "admin_group_name" {
  description = "Single platform admin group name granted CAN_MANAGE permission."
  type        = string
}

variable "user_group_names" {
  description = "List of group names granted CAN_USE permission."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Custom key-value tags to apply to the SQL warehouse."
  type        = map(string)
  default     = {}
}
