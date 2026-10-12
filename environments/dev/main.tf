/*
  Databricks Account Identity Management Orchestration - Dev Environment
  Documentation:
    - https://docs.databricks.com/aws/en/admin/users-groups/
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs

  Orchestrates account-level identity management and remote state storage:
    - Provisions customer-managed KMS key and S3 bucket for secure backend state storage.
    - Instantiates account-level Databricks users, groups, and service principals.
    - Manages group memberships (users, service principals, and nested groups).
    - Enforces service principal access control rule sets with sequenced dependencies.
*/

/* setup s3 backend for the project */

module "kms_key" {
  source = "../../modules/02.security/001.kms_key"

  environment         = local.env
  kms_key_alias       = "dbx_id_management_backend_kms_key"
  kms_key_description = "KMS key used for backend storage security"
}

module "backend_bucket" {
  source = "../../modules/03.storage/001.env_backend_bucket"

  bucket_name = local.backend_bucket_name
  environment = local.env
  kms_key_arn = module.kms_key.kms_arn
}


