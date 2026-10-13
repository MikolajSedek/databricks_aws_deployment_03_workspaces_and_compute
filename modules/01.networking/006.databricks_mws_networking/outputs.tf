/*
  Outputs - Databricks MWS Networking Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "network_id" {
  description = "The unique identifier of the registered Databricks MWS network configuration."
  value       = databricks_mws_networks.this.network_id
}

output "private_access_settings_id" {
  description = "The unique identifier of the Databricks Private Access Settings (PAS)."
  value       = databricks_mws_private_access_settings.pas.private_access_settings_id
}
