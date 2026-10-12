# dev

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.66.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 1.135.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.66.0 |
| <a name="provider_databricks.mws"></a> [databricks.mws](#provider\_databricks.mws) | 1.135.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend_bucket"></a> [backend\_bucket](#module\_backend\_bucket) | ../../modules/03.storage/001.env_backend_bucket | n/a |
| <a name="module_compute_data_analytics"></a> [compute\_data\_analytics](#module\_compute\_data\_analytics) | ../../modules/05.compute/004.workspace_compute | n/a |
| <a name="module_compute_data_engineering"></a> [compute\_data\_engineering](#module\_compute\_data\_engineering) | ../../modules/05.compute/004.workspace_compute | n/a |
| <a name="module_compute_data_science"></a> [compute\_data\_science](#module\_compute\_data\_science) | ../../modules/05.compute/004.workspace_compute | n/a |
| <a name="module_cross_account_role"></a> [cross\_account\_role](#module\_cross\_account\_role) | ../../modules/02.security/002.cross_account_role | n/a |
| <a name="module_kms_key"></a> [kms\_key](#module\_kms\_key) | ../../modules/02.security/001.kms_key | n/a |
| <a name="module_mws_networking"></a> [mws\_networking](#module\_mws\_networking) | ../../modules/01.networking/006.databricks_mws_networking | n/a |
| <a name="module_root_buckets"></a> [root\_buckets](#module\_root\_buckets) | ../../modules/03.storage/002.databricks_root_bucket | n/a |
| <a name="module_workspace_kms_keys"></a> [workspace\_kms\_keys](#module\_workspace\_kms\_keys) | ../../modules/02.security/001.kms_key | n/a |
| <a name="module_workspaces"></a> [workspaces](#module\_workspaces) | ../../modules/04.workspaces/001.generic_workspace | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.spoke_sg](https://registry.terraform.io/providers/hashicorp/aws/6.66.0/docs/data-sources/security_group) | data source |
| [aws_subnets.spoke_compute](https://registry.terraform.io/providers/hashicorp/aws/6.66.0/docs/data-sources/subnets) | data source |
| [aws_vpc.spoke](https://registry.terraform.io/providers/hashicorp/aws/6.66.0/docs/data-sources/vpc) | data source |
| [databricks_group.data_analysts](https://registry.terraform.io/providers/databricks/databricks/1.135.0/docs/data-sources/group) | data source |
| [databricks_group.data_engineers](https://registry.terraform.io/providers/databricks/databricks/1.135.0/docs/data-sources/group) | data source |
| [databricks_group.data_scientists](https://registry.terraform.io/providers/databricks/databricks/1.135.0/docs/data-sources/group) | data source |
| [databricks_group.platform_admins](https://registry.terraform.io/providers/databricks/databricks/1.135.0/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The allowed AWS Account ID to prevent accidental deployment to the wrong account. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where resources will be deployed. | `string` | `"eu-central-1"` | no |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | The Databricks account ID (UUID) used by the account-level provider. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment name (e.g. dev, staging, prod). | `string` | `"dev"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS CLI user profile | `string` | `"default"` | no |
| <a name="input_public_access_enabled"></a> [public\_access\_enabled](#input\_public\_access\_enabled) | Whether public internet access to the workspace web console is allowed (recommended true for dev). | `bool` | `true` | no |
| <a name="input_relay_vpce_service_name"></a> [relay\_vpce\_service\_name](#input\_relay\_vpce\_service\_name) | The AWS VPC Endpoint service name for Databricks SCC Relay (eu-central-1). | `string` | `"com.amazonaws.vpce.eu-central-1.vpce-svc-08e5dfca9572c85c4"` | no |
| <a name="input_service_principal_id"></a> [service\_principal\_id](#input\_service\_principal\_id) | The service principal ID for the Databricks workspace / account | `string` | n/a | yes |
| <a name="input_service_principal_secret"></a> [service\_principal\_secret](#input\_service\_principal\_secret) | The service principal secret for the Databricks workspace / account | `string` | n/a | yes |
| <a name="input_workspace_vpce_service_name"></a> [workspace\_vpce\_service\_name](#input\_workspace\_vpce\_service\_name) | The AWS VPC Endpoint service name for Databricks Workspace REST API (eu-central-1). | `string` | `"com.amazonaws.vpce.eu-central-1.vpce-svc-081f78503812597f7"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_bucket_name"></a> [backend\_bucket\_name](#output\_backend\_bucket\_name) | The S3 bucket name used for remote state storage. |
| <a name="output_cross_account_role_arn"></a> [cross\_account\_role\_arn](#output\_cross\_account\_role\_arn) | The ARN of the AWS IAM cross-account role assumed by Databricks. |
| <a name="output_mws_network_id"></a> [mws\_network\_id](#output\_mws\_network\_id) | The unique identifier of the registered Databricks MWS network configuration. |
| <a name="output_workspace_ids"></a> [workspace\_ids](#output\_workspace\_ids) | Map of workspace keys to their numeric Databricks workspace IDs. |
| <a name="output_workspace_urls"></a> [workspace\_urls](#output\_workspace\_urls) | Map of workspace keys to their access URLs. |
<!-- END_TF_DOCS -->
