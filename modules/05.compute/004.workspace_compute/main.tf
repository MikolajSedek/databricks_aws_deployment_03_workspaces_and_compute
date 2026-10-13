/*
  Databricks Workspace Compute Orchestration Module
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs

  Aggregates and orchestrates:
    - Compute policies (including max 25 DBU platform admin policy and shared policy)
    - Multiple all-purpose compute clusters governed by cluster policy
    - Multiple SQL Warehouses governed by role-based ACLs
*/

/* 1. Compute Policies for Workspace */
module "compute_policies" {
  source = "../001.compute_policies"

  admin_group_name = var.admin_group_name
  user_group_names = var.user_group_names
}

/* 2. All-Purpose Clusters (Supports multiple clusters per workspace) */
module "clusters" {
  for_each = var.clusters
  source   = "../002.all_purpose_cluster"

  cluster_name            = each.value.cluster_name
  spark_version           = each.value.spark_version
  node_type_id            = each.value.node_type_id
  policy_id               = coalesce(each.value.policy_id, module.compute_policies.shared_policy_id)
  min_workers             = each.value.min_workers
  max_workers             = each.value.max_workers
  autotermination_minutes = each.value.autotermination_minutes
  custom_tags             = each.value.custom_tags
  admin_group_name        = var.admin_group_name
  user_group_names        = each.value.user_group_names != null ? each.value.user_group_names : var.user_group_names
}

/* 3. SQL Warehouses (Supports multiple SQL Warehouses per workspace) */
module "sql_warehouses" {
  for_each = var.sql_warehouses
  source   = "../003.sql_warehouse"

  name                      = each.value.name
  cluster_size              = each.value.cluster_size
  min_num_clusters          = each.value.min_num_clusters
  max_num_clusters          = each.value.max_num_clusters
  auto_stop_mins            = each.value.auto_stop_mins
  warehouse_type            = each.value.warehouse_type
  enable_photon             = each.value.enable_photon
  enable_serverless_compute = each.value.enable_serverless_compute
  tags                      = each.value.tags
  admin_group_name          = var.admin_group_name
  user_group_names          = each.value.user_group_names != null ? each.value.user_group_names : var.user_group_names
}
