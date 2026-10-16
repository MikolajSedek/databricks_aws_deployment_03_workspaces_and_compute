/*
  Databricks MWS Networking and PrivateLink Connectivity Configuration
  Documentation:
    - https://docs.databricks.com/aws/en/security/network/classic/privatelink
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks
*/

/* Register Customer-Managed VPC in Databricks Account */
resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = var.network_name
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}
