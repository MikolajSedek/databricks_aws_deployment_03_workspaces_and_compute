/*
  Outputs - Databricks SQL Warehouse Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "endpoint_id" {
  description = "The unique identifier of the Databricks SQL Warehouse endpoint."
  value       = databricks_sql_endpoint.this.id
}

output "jdbc_url" {
  description = "The JDBC connection URL for connecting BI and SQL tools to this endpoint."
  value       = databricks_sql_endpoint.this.jdbc_url
}
