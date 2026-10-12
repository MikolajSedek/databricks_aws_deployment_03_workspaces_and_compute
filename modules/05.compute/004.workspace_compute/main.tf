/*
  Databricks Workspace Compute Orchestration Module
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs

  Aggregates and orchestrates:
    - Compute policies (including max 25 DBU admin policy and persona policy)
    - Multiple all-purpose compute clusters governed by the persona policy
    - Multiple SQL Warehouses governed by role-based ACLs
*/

/* 1. Compute Policies for Workspace */
module "compute_policies" {
  source = "../001.compute_policies"

  admin_group_name           = var.admin_group_name
  data_engineers_group_name  = var.persona_type == "data_engineering" ? var.persona_group_name : null
  data_scientists_group_name = var.persona_type == "data_science" ? var.persona_group_name : null
  data_analysts_group_name   = var.persona_type == "data_analytics" ? var.persona_group_name : null
}

locals {
  persona_policy_map = {
    data_engineering = module.compute_policies.policy_ids["data_engineers"]
    data_science     = module.compute_policies.policy_ids["data_scientists"]
    data_analytics   = module.compute_policies.policy_ids["data_analysts"]
  }
}

/* 2. All-Purpose Clusters (Supports multiple clusters per workspace) */
module "clusters" {
  for_each = var.clusters
  source   = "../002.all_purpose_cluster"

  cluster_name            = each.value.cluster_name
  spark_version           = each.value.spark_version
  node_type_id            = each.value.node_type_id
  policy_id               = local.persona_policy_map[var.persona_type]
  min_workers             = each.value.min_workers
  max_workers             = each.value.max_workers
  autotermination_minutes = each.value.autotermination_minutes
  custom_tags             = each.value.custom_tags
  admin_group_name        = var.admin_group_name
  user_group_name         = var.persona_group_name
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
  enable_serverless_compute = each.value.enable_serverless_compute
  tags                      = each.value.tags
  admin_group_name          = var.admin_group_name
  user_group_name           = var.persona_group_name
}
