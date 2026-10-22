/*
  Input Variables - Databricks Root Storage Bucket Module
  Documentation:
    - https://docs.databricks.com/aws/en/admin/cloud-configurations/aws/customer-managed-storage
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations
*/

variable "bucket_name" {
  description = "The globally unique name of the S3 root storage bucket."
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the AWS KMS key used to encrypt the S3 root bucket."
  type        = string
}

variable "databricks_account_id" {
  description = "The Databricks Account ID used for MWS storage registration."
  type        = string
}

variable "storage_configuration_name" {
  description = "The name of the Databricks MWS storage configuration."
  type        = string
}

variable "cross_account_role_arn" {
  description = "The ARN of the Databricks cross-account IAM role authorized on the bucket."
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow force destroy of all objects in the bucket when destroying."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of resource tags to attach to the S3 bucket."
  type        = map(string)
  default     = {}
}
