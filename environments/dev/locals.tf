/*
  Local Values and Multi-Workspace Configuration - Dev Environment
  Documentation:
    - https://developer.hashicorp.com/terraform/language/values/locals
    - https://docs.databricks.com/aws/en/admin/workspace/

  Defines declarative, structured maps of objects for provisioning:
    - Backend state storage resources.
    - Databricks Cross-Account IAM credentials and PrivateLink network parameters.
    - Dedicated root storage buckets and customer-managed KMS keys per workspace.
    - Databricks Workspaces for Data Engineering, Data Science, and Data Analytics personas.
    - Scoped compute clusters, SQL warehouses, and cluster policy bindings supporting multiple instances.
*/

locals {
  /* Basic Project Conventions */
  owner           = "msedek"
  env             = var.environment
  project_name    = "${local.owner}-dbx-dep"
  subproject_name = "workspaces-and-compute-provider"

  backend_bucket_name = "${local.project_name}-${local.subproject_name}-s3-backend"

  /* Cross-Account Role & MWS Network Names */
  cross_account_role_name = "${local.project_name}-cross-account-role-${local.env}"
  credentials_name        = "${local.project_name}-credentials-${local.env}"
  network_name            = "${local.project_name}-mws-network-${local.env}"

  /* Databricks Platform Administration Group */
  admin_group_name = data.databricks_group.platform_admins.display_name

  /* Declarative Multi-Workspace Configuration */
  workspaces = {
    data_engineering = {
      workspace_name   = "${local.project_name}-data-eng-${local.env}"
      root_bucket_name = "${local.project_name}-data-eng-root-${local.env}"
      kms_key_alias    = "dbx_de_root_kms"
      kms_description  = "Customer-managed KMS key for Data Engineering workspace root storage"
      admin_group_name = local.admin_group_name
      user_group_names = [data.databricks_group.data_engineers.display_name]

      clusters = {
        etl_shared = {
          cluster_name            = "de-etl-cluster-${local.env}"
          spark_version           = "18.x-scala2.13"
          node_type_id            = "m5.xlarge"
          runtime_engine          = "STANDARD"
          data_security_mode      = "USER_ISOLATION"
          enable_elastic_disk     = true
          min_workers             = 1
          max_workers             = 3
          autotermination_minutes = 30
          custom_tags = {
            Workload = "ETL"
          }
          user_group_names = [data.databricks_group.data_engineers.display_name]
        }
      }

      sql_warehouses = {
        primary = {
          name             = "de-sql-warehouse-${local.env}"
          cluster_size     = "2X-Small"
          auto_stop_mins   = 15
          user_group_names = [data.databricks_group.data_engineers.display_name]
        }
      }
    }

    data_science = {
      workspace_name   = "${local.project_name}-data-science-${local.env}"
      root_bucket_name = "${local.project_name}-data-science-root-${local.env}"
      kms_key_alias    = "dbx_ds_root_kms"
      kms_description  = "Customer-managed KMS key for Data Science workspace root storage"
      admin_group_name = local.admin_group_name
      user_group_names = [data.databricks_group.data_scientists.display_name]

      clusters = {
        ml_exploration = {
          cluster_name            = "ds-ml-cluster-${local.env}"
          spark_version           = "18.x-cpu-ml-scala2.13"
          node_type_id            = "m5.xlarge"
          runtime_engine          = "STANDARD"
          data_security_mode      = "USER_ISOLATION"
          enable_elastic_disk     = true
          min_workers             = 1
          max_workers             = 2
          autotermination_minutes = 20
          custom_tags = {
            Workload = "ModelTraining"
          }
          user_group_names = [data.databricks_group.data_scientists.display_name]
        }
      }

      sql_warehouses = {}
    }

    data_analytics = {
      workspace_name   = "${local.project_name}-data-analytics-${local.env}"
      root_bucket_name = "${local.project_name}-data-analytics-root-${local.env}"
      kms_key_alias    = "dbx_da_root_kms"
      kms_description  = "Customer-managed KMS key for Data Analytics workspace root storage"
      admin_group_name = local.admin_group_name
      user_group_names = [data.databricks_group.data_analysts.display_name]

      clusters = {}

      sql_warehouses = {
        bi_reporting = {
          name             = "da-bi-warehouse-${local.env}"
          cluster_size     = "X-Small"
          auto_stop_mins   = 10
          user_group_names = [data.databricks_group.data_analysts.display_name]
        }
      }
    }
  }
}
