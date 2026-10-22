## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.135.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.137.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_permissions.warehouse_permissions](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_sql_endpoint.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | Single platform admin group name granted CAN\_MANAGE permission. | `string` | n/a | yes |
| <a name="input_auto_stop_mins"></a> [auto\_stop\_mins](#input\_auto\_stop\_mins) | Time in minutes of inactivity before the warehouse automatically stops. | `number` | `15` | no |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | The size of the SQL Warehouse cluster (e.g. 2X-Small, X-Small, Small, Medium). | `string` | `"2X-Small"` | no |
| <a name="input_enable_photon"></a> [enable\_photon](#input\_enable\_photon) | Whether Photon engine acceleration is enabled. Must be true for PRO and Serverless SQL warehouses. | `bool` | `true` | no |
| <a name="input_enable_serverless_compute"></a> [enable\_serverless\_compute](#input\_enable\_serverless\_compute) | Whether serverless compute is enabled for this SQL Warehouse. Set to true to transition to Serverless SQL once workspace serverless compute prerequisites and terms are enabled. | `bool` | `false` | no |
| <a name="input_max_num_clusters"></a> [max\_num\_clusters](#input\_max\_num\_clusters) | Maximum number of clusters available for query processing. | `number` | `1` | no |
| <a name="input_min_num_clusters"></a> [min\_num\_clusters](#input\_min\_num\_clusters) | Minimum number of clusters available for query processing. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Databricks SQL Warehouse endpoint. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom key-value tags to apply to the SQL warehouse. | `map(string)` | `{}` | no |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of group names granted CAN\_USE permission. | `list(string)` | `[]` | no |
| <a name="input_warehouse_type"></a> [warehouse\_type](#input\_warehouse\_type) | The type of warehouse: only 'PRO' is supported (CLASSIC is not permitted). | `string` | `"PRO"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_id"></a> [endpoint\_id](#output\_endpoint\_id) | The unique identifier of the Databricks SQL Warehouse endpoint. |
| <a name="output_jdbc_url"></a> [jdbc\_url](#output\_jdbc\_url) | The JDBC connection URL for connecting BI and SQL tools to this endpoint. |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.135.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.137.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_permissions.warehouse_permissions](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_sql_endpoint.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | Single platform admin group name granted CAN\_MANAGE permission. | `string` | n/a | yes |
| <a name="input_auto_stop_mins"></a> [auto\_stop\_mins](#input\_auto\_stop\_mins) | Time in minutes of inactivity before the warehouse automatically stops. | `number` | `15` | no |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | The size of the SQL Warehouse cluster (e.g. 2X-Small, X-Small, Small, Medium). | `string` | `"2X-Small"` | no |
| <a name="input_enable_photon"></a> [enable\_photon](#input\_enable\_photon) | Whether Photon engine acceleration is enabled. Must be true for PRO and Serverless SQL warehouses. | `bool` | `true` | no |
| <a name="input_enable_serverless_compute"></a> [enable\_serverless\_compute](#input\_enable\_serverless\_compute) | Whether serverless compute is enabled for this SQL Warehouse. Set to true to transition to Serverless SQL once workspace serverless compute prerequisites and terms are enabled. | `bool` | `false` | no |
| <a name="input_max_num_clusters"></a> [max\_num\_clusters](#input\_max\_num\_clusters) | Maximum number of clusters available for query processing. | `number` | `1` | no |
| <a name="input_min_num_clusters"></a> [min\_num\_clusters](#input\_min\_num\_clusters) | Minimum number of clusters available for query processing. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Databricks SQL Warehouse endpoint. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom key-value tags to apply to the SQL warehouse. | `map(string)` | `{}` | no |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of group names granted CAN\_USE permission. | `list(string)` | `[]` | no |
| <a name="input_warehouse_type"></a> [warehouse\_type](#input\_warehouse\_type) | The type of warehouse: only 'PRO' is supported (CLASSIC is not permitted). | `string` | `"PRO"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
