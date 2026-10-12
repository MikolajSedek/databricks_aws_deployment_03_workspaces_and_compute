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

/* Authoritative admin assignment: dbx-platform-admins group receives ADMIN role across all workspaces */
resource "databricks_mws_permission_assignment" "admins" {
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = var.admin_principal_id
  permissions  = ["ADMIN"]

  depends_on = [databricks_mws_workspaces.this]
}

/* Persona group assignment: assigned USER role on their designated workspace */
resource "databricks_mws_permission_assignment" "persona" {
  count        = var.persona_principal_id != null ? 1 : 0
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = var.persona_principal_id
  permissions  = ["USER"]

  depends_on = [databricks_mws_workspaces.this]
}
