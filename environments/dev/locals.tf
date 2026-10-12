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
  subproject_name = "workspaces-compute-provider"

  backend_bucket_name = "${local.project_name}-${local.subproject_name}-s3-backend"

  /* Cross-Account Role & MWS Network Names */
  cross_account_role_name = "${local.project_name}-cross-account-role-${local.env}"
  credentials_name        = "${local.project_name}-credentials-${local.env}"
  network_name            = "${local.project_name}-mws-network-${local.env}"

  /* Declarative Multi-Workspace Configuration */
  workspaces = {
    data_engineering = {
      workspace_name     = "${local.project_name}-de-${local.env}"
      root_bucket_name   = "${local.project_name}-de-root-${local.env}"
      kms_key_alias      = "dbx_de_root_kms"
      kms_description    = "Customer-managed KMS key for Data Engineering workspace root storage"
      persona_group_id   = data.databricks_group.data_engineers.id
      persona_group_name = data.databricks_group.data_engineers.display_name

      clusters = {
        etl_shared = {
          cluster_name            = "de-etl-cluster-${local.env}"
          spark_version           = "15.4.x-scala2.12"
          node_type_id            = "m5.large"
          min_workers             = 1
          max_workers             = 3
          autotermination_minutes = 30
          custom_tags = {
            Workload = "ETL"
          }
        }
      }

      sql_warehouses = {
        primary = {
          name           = "de-sql-warehouse-${local.env}"
          cluster_size   = "2X-Small"
          auto_stop_mins = 15
        }
      }
    }

    data_science = {
      workspace_name     = "${local.project_name}-ds-${local.env}"
      root_bucket_name   = "${local.project_name}-ds-root-${local.env}"
      kms_key_alias      = "dbx_ds_root_kms"
      kms_description    = "Customer-managed KMS key for Data Science workspace root storage"
      persona_group_id   = data.databricks_group.data_scientists.id
      persona_group_name = data.databricks_group.data_scientists.display_name

      clusters = {
        ml_exploration = {
          cluster_name            = "ds-ml-cluster-${local.env}"
          spark_version           = "15.4.x-cpu-ml-scala2.12"
          node_type_id            = "m5.xlarge"
          min_workers             = 1
          max_workers             = 2
          autotermination_minutes = 20
          custom_tags = {
            Workload = "ModelTraining"
          }
        }
      }

      sql_warehouses = {}
    }

    data_analytics = {
      workspace_name     = "${local.project_name}-da-${local.env}"
      root_bucket_name   = "${local.project_name}-da-root-${local.env}"
      kms_key_alias      = "dbx_da_root_kms"
      kms_description    = "Customer-managed KMS key for Data Analytics workspace root storage"
      persona_group_id   = data.databricks_group.data_analysts.id
      persona_group_name = data.databricks_group.data_analysts.display_name

      clusters = {}

      sql_warehouses = {
        bi_reporting = {
          name           = "da-bi-warehouse-${local.env}"
          cluster_size   = "X-Small"
          auto_stop_mins = 10
        }
      }
    }
  }
}
