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
| [databricks_cluster.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster) | resource |
| [databricks_permissions.cluster_permissions](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | Single platform admin group name granted CAN\_MANAGE permission. | `string` | n/a | yes |
| <a name="input_autotermination_minutes"></a> [autotermination\_minutes](#input\_autotermination\_minutes) | Auto-termination timeout in minutes when the cluster is idle. | `number` | `30` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Databricks all-purpose cluster. | `string` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Additional tags to attach to the cluster. | `map(string)` | `{}` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | Maximum number of worker nodes for autoscaling. | `number` | `3` | no |
| <a name="input_min_workers"></a> [min\_workers](#input\_min\_workers) | Minimum number of worker nodes for autoscaling. | `number` | `1` | no |
| <a name="input_node_type_id"></a> [node\_type\_id](#input\_node\_type\_id) | The AWS EC2 instance type ID for worker and driver nodes. | `string` | n/a | yes |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | The Databricks cluster policy ID enforcing sizing and governance. | `string` | n/a | yes |
| <a name="input_spark_version"></a> [spark\_version](#input\_spark\_version) | The Databricks Runtime (DBR) version string (e.g. 15.4.x-scala2.12). | `string` | n/a | yes |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of group names granted CAN\_RESTART and CAN\_ATTACH\_TO permissions. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The unique identifier of the Databricks compute cluster. |

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
| [databricks_cluster.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster) | resource |
| [databricks_permissions.cluster_permissions](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | Single platform admin group name granted CAN\_MANAGE permission. | `string` | n/a | yes |
| <a name="input_autotermination_minutes"></a> [autotermination\_minutes](#input\_autotermination\_minutes) | Auto-termination timeout in minutes when the cluster is idle. | `number` | `30` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Databricks all-purpose cluster. | `string` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Additional tags to attach to the cluster. | `map(string)` | `{}` | no |
| <a name="input_data_security_mode"></a> [data\_security\_mode](#input\_data\_security\_mode) | The data security mode / access mode for Unity Catalog (e.g. 'USER\_ISOLATION', 'SINGLE\_USER'). Defaults to 'USER\_ISOLATION' to prevent NO\_ISOLATION errors in modern workspaces. | `string` | `"USER_ISOLATION"` | no |
| <a name="input_enable_elastic_disk"></a> [enable\_elastic\_disk](#input\_enable\_elastic\_disk) | Whether autoscaling local storage (elastic disk) is enabled for worker nodes to dynamically attach additional EBS storage as needed. | `bool` | `true` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | Maximum number of worker nodes for autoscaling. | `number` | `3` | no |
| <a name="input_min_workers"></a> [min\_workers](#input\_min\_workers) | Minimum number of worker nodes for autoscaling. | `number` | `1` | no |
| <a name="input_node_type_id"></a> [node\_type\_id](#input\_node\_type\_id) | The AWS EC2 instance type ID for worker and driver nodes. | `string` | n/a | yes |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | The Databricks cluster policy ID enforcing sizing and governance. | `string` | n/a | yes |
| <a name="input_runtime_engine"></a> [runtime\_engine](#input\_runtime\_engine) | The runtime engine type: 'STANDARD' or 'PHOTON'. Defaults to 'STANDARD' to explicitly disable Photon. | `string` | `"STANDARD"` | no |
| <a name="input_single_user_name"></a> [single\_user\_name](#input\_single\_user\_name) | The username or service principal client ID for single-user clusters when data\_security\_mode is 'SINGLE\_USER'. | `string` | `null` | no |
| <a name="input_spark_version"></a> [spark\_version](#input\_spark\_version) | The Databricks Runtime (DBR) version string (e.g. 15.4.x-scala2.12). | `string` | n/a | yes |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of group names granted CAN\_RESTART and CAN\_ATTACH\_TO permissions. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
