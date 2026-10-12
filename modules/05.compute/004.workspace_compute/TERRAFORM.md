# 004.workspace_compute

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.135.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_clusters"></a> [clusters](#module\_clusters) | ../002.all_purpose_cluster | n/a |
| <a name="module_compute_policies"></a> [compute\_policies](#module\_compute\_policies) | ../001.compute_policies | n/a |
| <a name="module_sql_warehouses"></a> [sql\_warehouses](#module\_sql\_warehouses) | ../003.sql_warehouse | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | Name of the platform admin group granted management access. | `string` | n/a | yes |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | Map of all-purpose compute cluster configurations for the workspace. | <pre>map(object({<br/>    cluster_name            = string<br/>    spark_version           = string<br/>    node_type_id            = string<br/>    min_workers             = number<br/>    max_workers             = number<br/>    autotermination_minutes = optional(number, 30)<br/>    custom_tags             = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_persona_group_name"></a> [persona\_group\_name](#input\_persona\_group\_name) | Name of the persona group (e.g. data\_engineers, data\_scientists, data\_analysts). | `string` | n/a | yes |
| <a name="input_persona_type"></a> [persona\_type](#input\_persona\_type) | Type of persona to configure: 'data\_engineering', 'data\_science', or 'data\_analytics'. | `string` | n/a | yes |
| <a name="input_sql_warehouses"></a> [sql\_warehouses](#input\_sql\_warehouses) | Map of SQL Warehouse endpoint configurations for the workspace. | <pre>map(object({<br/>    name                      = string<br/>    cluster_size              = optional(string, "2X-Small")<br/>    min_num_clusters          = optional(number, 1)<br/>    max_num_clusters          = optional(number, 1)<br/>    auto_stop_mins            = optional(number, 15)<br/>    warehouse_type            = optional(string, "PRO")<br/>    enable_serverless_compute = optional(bool, false)<br/>    tags                      = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_workspace_url"></a> [workspace\_url](#input\_workspace\_url) | The target workspace URL passed from the workspace module to establish upstream dependency. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ids"></a> [cluster\_ids](#output\_cluster\_ids) | Map of cluster configuration keys to their created cluster IDs. |
| <a name="output_policy_ids"></a> [policy\_ids](#output\_policy\_ids) | Map of compute cluster policy keys to their policy IDs. |
| <a name="output_sql_warehouse_ids"></a> [sql\_warehouse\_ids](#output\_sql\_warehouse\_ids) | Map of SQL Warehouse configuration keys to their endpoint IDs. |
| <a name="output_sql_warehouse_jdbc_urls"></a> [sql\_warehouse\_jdbc\_urls](#output\_sql\_warehouse\_jdbc\_urls) | Map of SQL Warehouse configuration keys to their JDBC URLs. |
<!-- END_TF_DOCS -->
