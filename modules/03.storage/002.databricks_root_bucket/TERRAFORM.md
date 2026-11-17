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
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.137.0 |
| <a name="provider_databricks.mws"></a> [databricks.mws](#provider\_databricks.mws) | 1.137.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_grant.cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_grant.databricks_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_s3_bucket.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [databricks_mws_customer_managed_keys.storage_cmk](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_customer_managed_keys) | resource |
| [databricks_mws_storage_configurations.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations) | resource |
| [databricks_aws_assume_role_policy.kms_trust](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_assume_role_policy) | data source |
| [databricks_aws_bucket_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_bucket_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The globally unique name of the S3 root storage bucket. | `string` | n/a | yes |
| <a name="input_cross_account_role_arn"></a> [cross\_account\_role\_arn](#input\_cross\_account\_role\_arn) | The ARN of the Databricks cross-account IAM role authorized on the bucket. | `string` | n/a | yes |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | The Databricks Account ID used for MWS storage registration. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow force destroy of all objects in the bucket when destroying. | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the AWS KMS key used to encrypt the S3 root bucket. | `string` | n/a | yes |
| <a name="input_storage_configuration_name"></a> [storage\_configuration\_name](#input\_storage\_configuration\_name) | The name of the Databricks MWS storage configuration. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of resource tags to attach to the S3 bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_customer_managed_key_id"></a> [customer\_managed\_key\_id](#output\_customer\_managed\_key\_id) | The Databricks MWS customer-managed key ID for storage encryption. |
| <a name="output_storage_configuration_id"></a> [storage\_configuration\_id](#output\_storage\_configuration\_id) | The unique identifier of the registered Databricks MWS storage configuration. |

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.68.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.137.0 |
| <a name="provider_databricks.mws"></a> [databricks.mws](#provider\_databricks.mws) | 1.137.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_grant.cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_grant.databricks_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_s3_bucket.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.root_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [databricks_mws_customer_managed_keys.storage_cmk](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_customer_managed_keys) | resource |
| [databricks_mws_storage_configurations.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations) | resource |
| [databricks_aws_assume_role_policy.kms_trust](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_assume_role_policy) | data source |
| [databricks_aws_bucket_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_bucket_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The globally unique name of the S3 root storage bucket. | `string` | n/a | yes |
| <a name="input_cross_account_role_arn"></a> [cross\_account\_role\_arn](#input\_cross\_account\_role\_arn) | The ARN of the Databricks cross-account IAM role authorized on the bucket. | `string` | n/a | yes |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | The Databricks Account ID used for MWS storage registration. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow force destroy of all objects in the bucket when destroying. | `bool` | `true` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the AWS KMS key used to encrypt the S3 root bucket. | `string` | n/a | yes |
| <a name="input_storage_configuration_name"></a> [storage\_configuration\_name](#input\_storage\_configuration\_name) | The name of the Databricks MWS storage configuration. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of resource tags to attach to the S3 bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_customer_managed_key_id"></a> [customer\_managed\_key\_id](#output\_customer\_managed\_key\_id) | The Databricks MWS customer-managed key ID for storage encryption. |
| <a name="output_storage_configuration_id"></a> [storage\_configuration\_id](#output\_storage\_configuration\_id) | The unique identifier of the registered Databricks MWS storage configuration. |
<!-- END_TF_DOCS -->
