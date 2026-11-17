## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.135.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks.mws"></a> [databricks.mws](#provider\_databricks.mws) | 1.137.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_mws_permission_assignment.admins](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_permission_assignment.persona](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_permission_assignment.users](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_workspaces.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces) | resource |
| [databricks_group.admin](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group) | data source |
| [databricks_group.users](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The Databricks Account ID. | `string` | n/a | yes |
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | The name of the platform administrator group (e.g. dbx-platform-admins). | `string` | `null` | no |
| <a name="input_admin_principal_id"></a> [admin\_principal\_id](#input\_admin\_principal\_id) | Deprecated principal ID of the platform administrators group. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the workspace will reside. | `string` | n/a | yes |
| <a name="input_credentials_id"></a> [credentials\_id](#input\_credentials\_id) | The Databricks MWS credentials ID (cross-account IAM role). | `string` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The Databricks MWS network ID (customer-managed VPC). | `string` | n/a | yes |
| <a name="input_persona_principal_id"></a> [persona\_principal\_id](#input\_persona\_principal\_id) | Deprecated principal ID of the persona group. | `string` | `null` | no |
| <a name="input_pricing_tier"></a> [pricing\_tier](#input\_pricing\_tier) | The pricing tier of the workspace (e.g. PREMIUM, ENTERPRISE). | `string` | `"ENTERPRISE"` | no |
| <a name="input_private_access_settings_id"></a> [private\_access\_settings\_id](#input\_private\_access\_settings\_id) | The Databricks MWS Private Access Settings ID. | `string` | n/a | yes |
| <a name="input_storage_configuration_id"></a> [storage\_configuration\_id](#input\_storage\_configuration\_id) | The Databricks MWS storage configuration ID (root S3 bucket). | `string` | n/a | yes |
| <a name="input_storage_customer_managed_key_id"></a> [storage\_customer\_managed\_key\_id](#input\_storage\_customer\_managed\_key\_id) | The Databricks MWS customer-managed key ID for storage encryption. | `string` | n/a | yes |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of user group names (e.g. ['dbx-data-engineers']) granted USER role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | The name of the Databricks workspace to create. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The unique numeric identifier of the provisioned Databricks workspace. |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | The full HTTPS URL for accessing the provisioned Databricks workspace. |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.135.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks.mws"></a> [databricks.mws](#provider\_databricks.mws) | 1.137.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_mws_permission_assignment.admins](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_permission_assignment.persona](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_permission_assignment.users](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |
| [databricks_mws_workspaces.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces) | resource |
| [databricks_group.admin](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group) | data source |
| [databricks_group.users](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The Databricks Account ID. | `string` | n/a | yes |
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | The name of the platform administrator group (e.g. dbx-platform-admins). | `string` | `null` | no |
| <a name="input_admin_principal_id"></a> [admin\_principal\_id](#input\_admin\_principal\_id) | Deprecated principal ID of the platform administrators group. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the workspace will reside. | `string` | n/a | yes |
| <a name="input_credentials_id"></a> [credentials\_id](#input\_credentials\_id) | The Databricks MWS credentials ID (cross-account IAM role). | `string` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The Databricks MWS network ID (customer-managed VPC). | `string` | n/a | yes |
| <a name="input_persona_principal_id"></a> [persona\_principal\_id](#input\_persona\_principal\_id) | Deprecated principal ID of the persona group. | `string` | `null` | no |
| <a name="input_pricing_tier"></a> [pricing\_tier](#input\_pricing\_tier) | The pricing tier of the workspace (e.g. PREMIUM, ENTERPRISE). | `string` | `"ENTERPRISE"` | no |
| <a name="input_private_access_settings_id"></a> [private\_access\_settings\_id](#input\_private\_access\_settings\_id) | The Databricks MWS Private Access Settings (PAS) ID for PrivateLink connectivity. | `string` | `null` | no |
| <a name="input_storage_configuration_id"></a> [storage\_configuration\_id](#input\_storage\_configuration\_id) | The Databricks MWS storage configuration ID (root S3 bucket). | `string` | n/a | yes |
| <a name="input_storage_customer_managed_key_id"></a> [storage\_customer\_managed\_key\_id](#input\_storage\_customer\_managed\_key\_id) | The Databricks MWS customer-managed key ID for storage encryption. | `string` | n/a | yes |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | List of user group names (e.g. ['dbx-data-engineers']) granted USER role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | The name of the Databricks workspace to create. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | The full HTTPS URL for accessing the provisioned Databricks workspace. |
<!-- END_TF_DOCS -->
