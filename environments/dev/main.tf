/*
  Databricks Multi-Workspace and Compute Orchestration - Dev Environment
  Documentation:
    - https://docs.databricks.com/aws/en/admin/workspace/
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs

  Root module orchestrating multi-workspace provisioning and scoped compute governance:
    - S3 backend bucket & KMS key for state persistence.
    - Databricks Cross-Account IAM role with propagation safeguards.
    - Databricks MWS Networking with AWS PrivateLink VPC endpoints.
    - Dedicated root storage S3 buckets encrypted with isolated customer-managed KMS keys.
    - Generic Databricks Workspaces for Data Engineering, Data Science, and Analytics personas.
    - Scoped compute policies (with max 25 DBU platform admin policy) and role-based permissions.
    - Autoscaled all-purpose compute clusters and cost-optimized SQL Warehouses.
*/

/* 1. Remote S3 State Backend Storage */

module "kms_key" {
  source = "../../modules/02.security/001.kms_key"

  environment         = local.env
  kms_key_alias       = "dbx_workspaces_compute_backend_kms_key"
  kms_key_description = "KMS key used for backend storage security"
}

module "backend_bucket" {
  source = "../../modules/03.storage/001.env_backend_bucket"

  bucket_name = local.backend_bucket_name
  environment = local.env
  kms_key_arn = module.kms_key.kms_arn
}

/* 2. Cross-Account IAM Role for Databricks */

module "cross_account_role" {
  source = "../../modules/02.security/002.cross_account_role"

  providers = {
    databricks.mws = databricks.mws
  }

  role_name             = local.cross_account_role_name
  databricks_account_id = var.databricks_account_id
  credentials_name      = local.credentials_name
}

/* 3. Databricks MWS Networking and PrivateLink */

module "mws_networking" {
  source = "../../modules/01.networking/006.databricks_mws_networking"

  providers = {
    databricks.mws = databricks.mws
  }

  databricks_account_id       = var.databricks_account_id
  network_name                = local.network_name
  vpc_id                      = data.aws_vpc.spoke.id
  subnet_ids                  = data.aws_subnets.spoke_compute.ids
  security_group_ids          = [data.aws_security_group.spoke_sg.id]
  aws_region                  = var.aws_region
  workspace_vpce_service_name = var.workspace_vpce_service_name
  relay_vpce_service_name     = var.relay_vpce_service_name
  public_access_enabled       = var.public_access_enabled
}

/* 4. Dedicated Customer-Managed KMS Keys per Workspace */

module "workspace_kms_keys" {
  for_each = local.workspaces

  source = "../../modules/02.security/001.kms_key"

  environment         = local.env
  kms_key_alias       = each.value.kms_key_alias
  kms_key_description = each.value.kms_description
}

/* 5. Dedicated S3 Root Storage Buckets per Workspace */

module "root_buckets" {
  for_each = local.workspaces

  source = "../../modules/03.storage/002.databricks_root_bucket"

  providers = {
    databricks.mws = databricks.mws
  }

  bucket_name                = each.value.root_bucket_name
  kms_key_arn                = module.workspace_kms_keys[each.key].kms_arn
  databricks_account_id      = var.databricks_account_id
  storage_configuration_name = "${each.value.workspace_name}-storage"
  cross_account_role_arn     = module.cross_account_role.role_arn
}

/* 6. Generic Databricks Workspaces */

module "workspaces" {
  for_each = local.workspaces

  source = "../../modules/04.workspaces/001.generic_workspace"

  providers = {
    databricks.mws = databricks.mws
  }

  account_id                      = var.databricks_account_id
  aws_region                      = var.aws_region
  workspace_name                  = each.value.workspace_name
  credentials_id                  = module.cross_account_role.credentials_id
  storage_configuration_id        = module.root_buckets[each.key].storage_configuration_id
  network_id                      = module.mws_networking.network_id
  storage_customer_managed_key_id = module.root_buckets[each.key].customer_managed_key_id
  private_access_settings_id      = module.mws_networking.private_access_settings_id
  admin_principal_id              = data.databricks_group.platform_admins.id
  persona_principal_id            = each.value.persona_group_id
}

/* 7. Workspace Compute Orchestrations (Multiple Clusters & SQL Warehouses supported) */

module "compute_data_engineering" {
  source = "../../modules/05.compute/004.workspace_compute"

  providers = {
    databricks = databricks.workspace_de
  }

  workspace_url      = module.workspaces["data_engineering"].workspace_url
  admin_group_name   = data.databricks_group.platform_admins.display_name
  persona_group_name = local.workspaces.data_engineering.persona_group_name
  persona_type       = "data_engineering"
  clusters           = local.workspaces.data_engineering.clusters
  sql_warehouses     = local.workspaces.data_engineering.sql_warehouses
}

module "compute_data_science" {
  source = "../../modules/05.compute/004.workspace_compute"

  providers = {
    databricks = databricks.workspace_ds
  }

  workspace_url      = module.workspaces["data_science"].workspace_url
  admin_group_name   = data.databricks_group.platform_admins.display_name
  persona_group_name = local.workspaces.data_science.persona_group_name
  persona_type       = "data_science"
  clusters           = local.workspaces.data_science.clusters
  sql_warehouses     = local.workspaces.data_science.sql_warehouses
}

module "compute_data_analytics" {
  source = "../../modules/05.compute/004.workspace_compute"

  providers = {
    databricks = databricks.workspace_da
  }

  workspace_url      = module.workspaces["data_analytics"].workspace_url
  admin_group_name   = data.databricks_group.platform_admins.display_name
  persona_group_name = local.workspaces.data_analytics.persona_group_name
  persona_type       = "data_analytics"
  clusters           = local.workspaces.data_analytics.clusters
  sql_warehouses     = local.workspaces.data_analytics.sql_warehouses
}
