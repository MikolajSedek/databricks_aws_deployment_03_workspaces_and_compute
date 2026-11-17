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
| [databricks_cluster_policy.shared_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_permissions.admin_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_permissions.shared_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | The workspace group name for platform administrators (e.g. dbx-platform-admins). | `string` | n/a | yes |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of user group names granted CAN\_USE permission on the shared policy. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_shared_policy_id"></a> [shared\_policy\_id](#output\_shared\_policy\_id) | The shared cluster policy ID governing workspace compute clusters. |

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
| [databricks_cluster_policy.shared_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_permissions.admin_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_permissions.shared_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | The workspace group name for platform administrators (e.g. dbx-platform-admins). | `string` | n/a | yes |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of user group names granted CAN\_USE permission on the shared policy. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_shared_policy_id"></a> [shared\_policy\_id](#output\_shared\_policy\_id) | The shared cluster policy ID governing workspace compute clusters. |
<!-- END_TF_DOCS -->
