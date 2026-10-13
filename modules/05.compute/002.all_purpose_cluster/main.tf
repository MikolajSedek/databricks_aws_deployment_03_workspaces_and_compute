/*
  Databricks All-Purpose Compute Cluster Configuration
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions
*/

resource "databricks_cluster" "this" {
  cluster_name            = var.cluster_name
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  policy_id               = var.policy_id
  autotermination_minutes = var.autotermination_minutes

  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }

  custom_tags = merge(
    var.custom_tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

resource "databricks_permissions" "cluster_permissions" {
  cluster_id = databricks_cluster.this.id

  access_control {
    group_name       = var.admin_group_name
    permission_level = "CAN_MANAGE"
  }

  dynamic "access_control" {
    for_each = var.user_group_names
    content {
      group_name       = access_control.value
      permission_level = "CAN_RESTART"
    }
  }
}
