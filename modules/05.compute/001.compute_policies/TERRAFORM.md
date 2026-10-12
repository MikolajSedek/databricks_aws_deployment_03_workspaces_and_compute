# 001.compute_policies

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
| [databricks_cluster_policy.admin_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_cluster_policy.data_analysts](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_cluster_policy.data_engineers](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_cluster_policy.data_scientists](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_permissions.admin_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_permissions.data_analysts](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_permissions.data_engineers](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_permissions.data_scientists](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | The workspace group name for platform administrators (e.g. dbx-platform-admins). | `string` | n/a | yes |
| <a name="input_data_analysts_group_name"></a> [data\_analysts\_group\_name](#input\_data\_analysts\_group\_name) | The workspace group name for data analysts (e.g. dbx-data-analysts). | `string` | `null` | no |
| <a name="input_data_engineers_group_name"></a> [data\_engineers\_group\_name](#input\_data\_engineers\_group\_name) | The workspace group name for data engineers (e.g. dbx-data-engineers). | `string` | `null` | no |
| <a name="input_data_scientists_group_name"></a> [data\_scientists\_group\_name](#input\_data\_scientists\_group\_name) | The workspace group name for data scientists (e.g. dbx-data-scientists). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_ids"></a> [policy\_ids](#output\_policy\_ids) | Map of compute cluster policy keys to their created policy IDs. |
<!-- END_TF_DOCS -->
