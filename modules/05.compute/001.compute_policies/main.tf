/*
  Databricks Compute Cluster Policies Configuration
  Documentation:
    - https://docs.databricks.com/aws/en/admin/clusters/policies
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions
*/

/* 1. Platform Admin Compute Policy (Strictly capped at max 10 DBUs / node budget) */
resource "databricks_cluster_policy" "admin_policy" {
  name = "Platform Admin Capped Policy (Max 10 DBU)"

  definition = jsonencode({
    "dbus_per_hour" = {
      "type"         = "range"
      "maxValue"     = 10
      "defaultValue" = 8
    }
    "autoscale.max_workers" = {
      "type"         = "range"
      "maxValue"     = 4
      "defaultValue" = 2
    }
    "node_type_id" = {
      "type"         = "allowlist"
      "values"       = ["m5.large", "m5.xlarge", "c5.xlarge"]
      "defaultValue" = "m5.large"
    }
    "autotermination_minutes" = {
      "type"         = "range"
      "maxValue"     = 45
      "defaultValue" = 30
    }
    "custom_tags.PolicyType" = {
      "type"  = "fixed"
      "value" = "PlatformAdmin-Capped-10DBU"
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

/* 2. Data Engineering Compute Policy */
resource "databricks_cluster_policy" "data_engineers" {
  name = "Data Engineering ETL Policy"

  definition = jsonencode({
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
    "node_type_id" = {
      "type"         = "allowlist"
      "values"       = ["m5.large", "m5.xlarge", "i3.xlarge"]
      "defaultValue" = "m5.large"
    }
    "autotermination_minutes" = {
      "type"         = "range"
      "maxValue"     = 30
      "defaultValue" = 20
    }
    "custom_tags.Team" = {
      "type"  = "fixed"
      "value" = "DataEngineering"
    }
  })
}

resource "databricks_permissions" "data_engineers" {
  count             = var.data_engineers_group_name != null ? 1 : 0
  cluster_policy_id = databricks_cluster_policy.data_engineers.id

  access_control {
    group_name       = var.admin_group_name
    permission_level = "CAN_USE"
  }

  access_control {
    group_name       = var.data_engineers_group_name
    permission_level = "CAN_USE"
  }
}

/* 3. Data Science Compute Policy (ML Runtimes & Single-User Mode) */
resource "databricks_cluster_policy" "data_scientists" {
  name = "Data Science ML Policy"

  definition = jsonencode({
    "data_security_mode" = {
      "type"         = "fixed"
      "value"        = "SINGLE_USER"
      "defaultValue" = "SINGLE_USER"
    }
    "autoscale.min_workers" = {
      "type"         = "fixed"
      "value"        = 1
      "defaultValue" = 1
    }
    "autoscale.max_workers" = {
      "type"         = "range"
      "maxValue"     = 2
      "defaultValue" = 1
    }
    "node_type_id" = {
      "type"         = "allowlist"
      "values"       = ["m5.large", "m5.xlarge", "g4dn.xlarge"]
      "defaultValue" = "m5.xlarge"
    }
    "autotermination_minutes" = {
      "type"         = "range"
      "maxValue"     = 25
      "defaultValue" = 20
    }
    "custom_tags.Team" = {
      "type"  = "fixed"
      "value" = "DataScience"
    }
  })
}

resource "databricks_permissions" "data_scientists" {
  count             = var.data_scientists_group_name != null ? 1 : 0
  cluster_policy_id = databricks_cluster_policy.data_scientists.id

  access_control {
    group_name       = var.admin_group_name
    permission_level = "CAN_USE"
  }

  access_control {
    group_name       = var.data_scientists_group_name
    permission_level = "CAN_USE"
  }
}

/* 4. Data Analytics Compute Policy (Restricted single-node small compute) */
resource "databricks_cluster_policy" "data_analysts" {
  name = "Data Analytics Ad-Hoc Policy"

  definition = jsonencode({
    "num_workers" = {
      "type"         = "fixed"
      "value"        = 0
      "defaultValue" = 0
    }
    "spark_conf.spark.databricks.cluster.profile" = {
      "type"  = "fixed"
      "value" = "singleNode"
    }
    "node_type_id" = {
      "type"         = "allowlist"
      "values"       = ["m5.large"]
      "defaultValue" = "m5.large"
    }
    "autotermination_minutes" = {
      "type"         = "range"
      "maxValue"     = 15
      "defaultValue" = 10
    }
    "custom_tags.Team" = {
      "type"  = "fixed"
      "value" = "DataAnalytics"
    }
  })
}

resource "databricks_permissions" "data_analysts" {
  count             = var.data_analysts_group_name != null ? 1 : 0
  cluster_policy_id = databricks_cluster_policy.data_analysts.id

  access_control {
    group_name       = var.admin_group_name
    permission_level = "CAN_USE"
  }

  access_control {
    group_name       = var.data_analysts_group_name
    permission_level = "CAN_USE"
  }
}
