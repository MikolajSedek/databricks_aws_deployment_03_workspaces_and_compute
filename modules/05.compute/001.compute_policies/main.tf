/*
  Databricks Compute Cluster Policies Configuration
  Documentation:
    - https://docs.databricks.com/aws/en/admin/clusters/policies
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions
*/

/* 1. Platform Admin Compute Policy (Strictly capped at max 25 DBUs / hour) */
resource "databricks_cluster_policy" "admin_policy" {
  name = "Platform Admin Capped Policy (Max 25 DBU)"

  definition = jsonencode({
    "dbus_per_hour" = {
      "type"     = "range"
      "maxValue" = 25
    }
    "autoscale.max_workers" = {
      "type"         = "range"
      "maxValue"     = 4
      "defaultValue" = 2
    }
    "runtime_engine" = {
      "type"         = "allowlist"
      "values"       = ["PHOTON", "STANDARD"]
      "defaultValue" = "PHOTON"
    }
    "data_security_mode" = {
      "type"         = "allowlist"
      "values"       = ["USER_ISOLATION", "SINGLE_USER"]
      "defaultValue" = "USER_ISOLATION"
    }
    "enable_elastic_disk" = {
      "type"         = "fixed"
      "value"        = true
      "defaultValue" = true
    }
    "node_type_id" = {
      "type" = "allowlist"
      "values" = [
        "m5.xlarge",
        "m5.2xlarge",
        "m6i.xlarge",
        "m6i.2xlarge",
        "c5.xlarge",
        "c5.2xlarge",
        "c6i.xlarge",
        "c6i.2xlarge",
        "r5.xlarge",
        "r5.2xlarge",
        "r6i.xlarge",
        "r6i.2xlarge",
        "i3.xlarge",
        "i3.2xlarge",
        "i4i.xlarge",
        "i4i.2xlarge"
      ]
      "defaultValue" = "m5.xlarge"
    }
    "spark_version" = {
      "type" = "allowlist"
      "values" = [
        "auto:latest-lts",
        "auto:prev-lts",
        "auto:latest",
        "auto:prev-major"
      ]
      "defaultValue" = "auto:latest-lts"
    }
    "autotermination_minutes" = {
      "type"         = "range"
      "maxValue"     = 45
      "defaultValue" = 30
    }
    "custom_tags.PolicyType" = {
      "type"  = "fixed"
      "value" = "PlatformAdmin-Capped-25DBU"
    }
  })
}

resource "databricks_permissions" "admin_policy" {
  cluster_policy_id = databricks_cluster_policy.admin_policy.id

  access_control {
    group_name       = var.admin_group_name
    permission_level = "CAN_USE"
  }
}

/* 2. Shared Workspace Compute Policy (Governs general team compute) */
resource "databricks_cluster_policy" "shared_policy" {
  name = "Workspace Shared Compute Policy"

  definition = jsonencode({
    "dbus_per_hour" = {
      "type"     = "range"
      "maxValue" = 15
    }
    "autoscale.min_workers" = {
      "type"         = "fixed"
      "value"        = 1
      "defaultValue" = 1
    }
    "autoscale.max_workers" = {
      "type"         = "range"
      "maxValue"     = 4
      "defaultValue" = 2
    }
    "runtime_engine" = {
      "type"         = "allowlist"
      "values"       = ["PHOTON", "STANDARD"]
      "defaultValue" = "PHOTON"
    }
    "data_security_mode" = {
      "type"         = "allowlist"
      "values"       = ["USER_ISOLATION", "SINGLE_USER"]
      "defaultValue" = "USER_ISOLATION"
    }
    "enable_elastic_disk" = {
      "type"         = "fixed"
      "value"        = true
      "defaultValue" = true
    }
    "node_type_id" = {
      "type" = "allowlist"
      "values" = [
        "m5.xlarge",
        "m5.2xlarge",
        "m6i.xlarge",
        "m6i.2xlarge",
        "c5.xlarge",
        "c5.2xlarge",
        "c6i.xlarge",
        "c6i.2xlarge",
        "r5.xlarge",
        "r5.2xlarge",
        "r6i.xlarge",
        "r6i.2xlarge",
        "i3.xlarge",
        "i3.2xlarge",
        "i4i.xlarge",
        "i4i.2xlarge"
      ]
      "defaultValue" = "m5.xlarge"
    }
    "spark_version" = {
      "type" = "allowlist"
      "values" = [
        "auto:latest-lts",
        "auto:prev-lts",
        "auto:latest-lts-ml",
        "auto:prev-lts-ml",
        "auto:latest",
        "auto:prev-major"
      ]
      "defaultValue" = "auto:latest-lts"
    }
    "autotermination_minutes" = {
      "type"         = "range"
      "maxValue"     = 30
      "defaultValue" = 20
    }
    "custom_tags.ManagedBy" = {
      "type"  = "fixed"
      "value" = "Terraform"
    }
  })
}

resource "databricks_permissions" "shared_policy" {
  cluster_policy_id = databricks_cluster_policy.shared_policy.id

  access_control {
    group_name       = var.admin_group_name
    permission_level = "CAN_USE"
  }

  dynamic "access_control" {
    for_each = var.user_group_names
    content {
      group_name       = access_control.value
      permission_level = "CAN_USE"
    }
  }
}
