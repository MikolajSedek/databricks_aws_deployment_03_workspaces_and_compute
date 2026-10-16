/*
  Outputs - Databricks MWS Networking Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "network_id" {
  description = "The unique identifier of the registered Databricks MWS network configuration."
  value       = databricks_mws_networks.this.network_id
}
