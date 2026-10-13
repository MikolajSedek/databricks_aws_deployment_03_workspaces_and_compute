/*
  Generic Databricks Workspace and Account Permission Assignment Configuration
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment
*/

resource "databricks_mws_workspaces" "this" {
  provider                        = databricks.mws
  account_id                      = var.account_id
  aws_region                      = var.aws_region
  workspace_name                  = var.workspace_name
  credentials_id                  = var.credentials_id
  storage_configuration_id        = var.storage_configuration_id
  network_id                      = var.network_id
  storage_customer_managed_key_id = var.storage_customer_managed_key_id
  private_access_settings_id      = var.private_access_settings_id
  pricing_tier                    = var.pricing_tier
}

/* Data source lookup for admin group */
data "databricks_group" "admin" {
  count        = var.admin_group_name != null ? 1 : 0
  provider     = databricks.mws
  display_name = var.admin_group_name
}

/* Data source lookup for user groups */
data "databricks_group" "users" {
  for_each     = toset(var.user_group_names)
  provider     = databricks.mws
  display_name = each.value
}

locals {
  resolved_admin_principal_id = var.admin_group_name != null ? data.databricks_group.admin[0].id : var.admin_principal_id
}

/* Authoritative admin assignment: dbx-platform-admins group receives ADMIN role across all workspaces */
resource "databricks_mws_permission_assignment" "admins" {
  count        = local.resolved_admin_principal_id != null ? 1 : 0
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = local.resolved_admin_principal_id
  permissions  = ["ADMIN"]

  depends_on = [databricks_mws_workspaces.this]
}

/* User group assignment: assigned USER role on their designated workspace */
resource "databricks_mws_permission_assignment" "users" {
  for_each     = data.databricks_group.users
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = each.value.id
  permissions  = ["USER"]

  depends_on = [databricks_mws_workspaces.this]
}

/* Backward-compatible fallback if persona_principal_id is passed and user_group_names is empty */
resource "databricks_mws_permission_assignment" "persona" {
  count        = (length(var.user_group_names) == 0 && var.persona_principal_id != null) ? 1 : 0
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = var.persona_principal_id
  permissions  = ["USER"]

  depends_on = [databricks_mws_workspaces.this]
}
