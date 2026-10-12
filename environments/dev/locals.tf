/*
  Local Values and Identity Model Configuration - Dev Environment
  Documentation:
    - https://developer.hashicorp.com/terraform/language/values/locals
    - https://docs.databricks.com/aws/en/admin/users-groups/

  Defines local variables, naming conventions, and the Databricks account identity catalogue:
    - Project, environment, and backend bucket naming parameters.
    - User identities parameterized from input variables.
    - Group declarations with administrative privilege toggles.
    - Service principals for automation, ETL, and data science workloads.
    - Group memberships mapping users and service principals to groups.
    - Authoritative role mappings granting groups manager/user access on service principals.
*/

locals {
  /* basic setup */

  owner           = "msedek" // NOTE: change it to your name
  env             = var.environment
  project_name    = "${local.owner}-dbx-dep"
  subproject_name = "workspaces-compute-provider"

  backend_bucket_name = "${local.project_name}-${local.subproject_name}-s3-backend"


