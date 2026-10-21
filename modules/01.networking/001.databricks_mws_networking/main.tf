/*
  Databricks MWS Networking and PrivateLink Connectivity Configuration
  Documentation:
    - https://docs.databricks.com/aws/en/security/network/classic/privatelink
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/aws-private-link-workspace
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_vpc_endpoint
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_private_access_settings
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks
*/

/* 1. Register Back-end Workspace (REST API) AWS VPC Endpoint in Databricks Account */
resource "databricks_mws_vpc_endpoint" "backend_rest" {
  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = var.workspace_vpce_id
  vpc_endpoint_name   = "${var.network_name}-rest-vpce"
  region              = var.aws_region
}

/* 2. Register Back-end Secure Cluster Connectivity (SCC) Relay AWS VPC Endpoint in Databricks Account */
resource "databricks_mws_vpc_endpoint" "relay" {
  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = var.relay_vpce_id
  vpc_endpoint_name   = "${var.network_name}-relay-vpce"
  region              = var.aws_region
}

/* 3. Configure Databricks Private Access Settings (PAS) for Control Plane Private Connectivity */
resource "databricks_mws_private_access_settings" "pas" {
  provider                     = databricks.mws
  private_access_settings_name = "${var.network_name}-pas"
  region                       = var.aws_region
  public_access_enabled        = var.public_access_enabled
  private_access_level         = var.private_access_level
  allowed_vpc_endpoint_ids = var.private_access_level == "ENDPOINT" ? [
    databricks_mws_vpc_endpoint.backend_rest.vpc_endpoint_id,
    databricks_mws_vpc_endpoint.relay.vpc_endpoint_id
  ] : null
}

/* 4. Register Customer-Managed Spoke VPC and PrivateLink Endpoints in Databricks Account */
resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = var.network_name
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  vpc_endpoints {
    rest_api        = [databricks_mws_vpc_endpoint.backend_rest.vpc_endpoint_id]
    dataplane_relay = [databricks_mws_vpc_endpoint.relay.vpc_endpoint_id]
  }

  depends_on = [
    databricks_mws_vpc_endpoint.backend_rest,
    databricks_mws_vpc_endpoint.relay
  ]
}
