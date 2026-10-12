/*
  Databricks SQL Warehouse and Object Permissions Configuration
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions
*/

resource "databricks_sql_endpoint" "this" {
  name                      = var.name
  cluster_size              = var.cluster_size
  min_num_clusters          = var.min_num_clusters
  max_num_clusters          = var.max_num_clusters
  auto_stop_mins            = var.auto_stop_mins
  warehouse_type            = var.warehouse_type
  enable_serverless_compute = var.enable_serverless_compute

  tags {
    dynamic "custom_tags" {
      for_each = var.tags
      content {
        key   = custom_tags.key
        value = custom_tags.value
      }
    }
  }
}

resource "databricks_permissions" "warehouse_permissions" {
  sql_endpoint_id = databricks_sql_endpoint.this.id

  access_control {
    group_name       = var.admin_group_name
    permission_level = "CAN_MANAGE"
  }

  dynamic "access_control" {
    for_each = var.user_group_name != null ? [var.user_group_name] : []
    content {
      group_name       = access_control.value
      permission_level = "CAN_USE"
    }
  }
}
