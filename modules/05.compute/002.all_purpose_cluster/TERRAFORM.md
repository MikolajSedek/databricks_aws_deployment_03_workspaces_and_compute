# 002.all_purpose_cluster

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
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | Group name granted CAN\_MANAGE permission. | `string` | n/a | yes |
| <a name="input_autotermination_minutes"></a> [autotermination\_minutes](#input\_autotermination\_minutes) | Auto-termination timeout in minutes when the cluster is idle. | `number` | `30` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Databricks all-purpose cluster. | `string` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Additional tags to attach to the cluster. | `map(string)` | `{}` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | Maximum number of worker nodes for autoscaling. | `number` | `3` | no |
| <a name="input_min_workers"></a> [min\_workers](#input\_min\_workers) | Minimum number of worker nodes for autoscaling. | `number` | `1` | no |
| <a name="input_node_type_id"></a> [node\_type\_id](#input\_node\_type\_id) | The AWS EC2 instance type ID for worker and driver nodes. | `string` | n/a | yes |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | The Databricks cluster policy ID enforcing sizing and governance. | `string` | n/a | yes |
| <a name="input_spark_version"></a> [spark\_version](#input\_spark\_version) | The Databricks Runtime (DBR) version string (e.g. 15.4.x-scala2.12). | `string` | n/a | yes |
| <a name="input_user_group_name"></a> [user\_group\_name](#input\_user\_group\_name) | Group name granted CAN\_RESTART and CAN\_ATTACH\_TO permission. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The unique identifier of the Databricks compute cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Databricks compute cluster. |
<!-- END_TF_DOCS -->
