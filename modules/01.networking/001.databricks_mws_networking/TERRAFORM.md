## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.135.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.68.0 |
| <a name="provider_databricks.mws"></a> [databricks.mws](#provider\_databricks.mws) | 1.137.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.privatelink_vpce_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.backend_rest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.relay](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [databricks_mws_networks.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks) | resource |
| [databricks_mws_private_access_settings.pas](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_private_access_settings) | resource |
| [databricks_mws_vpc_endpoint.backend_rest](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_vpc_endpoint) | resource |
| [databricks_mws_vpc_endpoint.relay](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where networking resources are deployed. | `string` | `"eu-central-1"` | no |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | The Databricks Account ID used for MWS resources. | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the Databricks MWS network configuration. | `string` | n/a | yes |
| <a name="input_private_access_level"></a> [private\_access\_level](#input\_private\_access\_level) | Private access level for PAS (ACCOUNT or ENDPOINT). | `string` | `"ACCOUNT"` | no |
| <a name="input_public_access_enabled"></a> [public\_access\_enabled](#input\_public\_access\_enabled) | Whether public internet access to the workspace web console is allowed (recommended true for dev). | `bool` | `true` | no |
| <a name="input_relay_vpce_service_name"></a> [relay\_vpce\_service\_name](#input\_relay\_vpce\_service\_name) | The AWS VPC Endpoint service name for Databricks SCC Relay (eu-central-1). | `string` | `"com.amazonaws.vpce.eu-central-1.vpce-svc-08e5dfca9572c85c4"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for Databricks compute clusters. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of private compute subnet IDs within the Spoke VPC. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of resource tags to assign to AWS networking resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The AWS VPC ID of the Spoke VPC. | `string` | n/a | yes |
| <a name="input_workspace_vpce_service_name"></a> [workspace\_vpce\_service\_name](#input\_workspace\_vpce\_service\_name) | The AWS VPC Endpoint service name for Databricks Workspace REST API (eu-central-1). | `string` | `"com.amazonaws.vpce.eu-central-1.vpce-svc-081f78503812597f7"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The unique identifier of the registered Databricks MWS network configuration. |
| <a name="output_private_access_settings_id"></a> [private\_access\_settings\_id](#output\_private\_access\_settings\_id) | The unique identifier of the Databricks Private Access Settings (PAS). |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
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
| [databricks_mws_networks.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks) | resource |
| [databricks_mws_private_access_settings.pas](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_private_access_settings) | resource |
| [databricks_mws_vpc_endpoint.backend_rest](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_vpc_endpoint) | resource |
| [databricks_mws_vpc_endpoint.relay](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the Spoke VPC and PrivateLink VPC endpoints reside. | `string` | n/a | yes |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | The Databricks Account ID used for MWS resources. | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the Databricks MWS network configuration. | `string` | n/a | yes |
| <a name="input_private_access_level"></a> [private\_access\_level](#input\_private\_access\_level) | Private access level for Databricks Private Access Settings (ACCOUNT or ENDPOINT). | `string` | `"ACCOUNT"` | no |
| <a name="input_public_access_enabled"></a> [public\_access\_enabled](#input\_public\_access\_enabled) | Whether public internet access to the workspace web console is allowed alongside PrivateLink. | `bool` | `true` | no |
| <a name="input_relay_vpce_id"></a> [relay\_vpce\_id](#input\_relay\_vpce\_id) | The AWS VPC Endpoint ID (vpce-*) for the Databricks Secure Cluster Connectivity (SCC) Relay PrivateLink endpoint. | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for Databricks compute clusters. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of private compute subnet IDs within the Spoke VPC. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The AWS VPC ID of the Spoke VPC. | `string` | n/a | yes |
| <a name="input_workspace_vpce_id"></a> [workspace\_vpce\_id](#input\_workspace\_vpce\_id) | The AWS VPC Endpoint ID (vpce-*) for the Databricks Workspace (REST API) PrivateLink endpoint. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The unique identifier of the registered Databricks MWS network configuration. |
| <a name="output_private_access_settings_id"></a> [private\_access\_settings\_id](#output\_private\_access\_settings\_id) | The canonical unique identifier of the Databricks Private Access Settings (PAS) configuration. |
<!-- END_TF_DOCS -->
