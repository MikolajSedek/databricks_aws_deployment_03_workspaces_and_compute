/*
  Outputs - Databricks Root Storage Bucket Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "storage_configuration_id" {
  description = "The unique identifier of the registered Databricks MWS storage configuration."
  value       = databricks_mws_storage_configurations.this.storage_configuration_id
}

output "customer_managed_key_id" {
  description = "The Databricks MWS customer-managed key ID for storage encryption."
  value       = databricks_mws_customer_managed_keys.storage_cmk.customer_managed_key_id
}
