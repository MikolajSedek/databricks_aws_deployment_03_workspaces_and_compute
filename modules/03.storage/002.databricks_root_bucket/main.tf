/*
  Databricks S3 Root Storage Bucket and MWS Storage Configuration
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_bucket_policy
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_customer_managed_keys
*/

resource "aws_s3_bucket" "root_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name = var.bucket_name
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "root_bucket" {
  bucket                  = aws_s3_bucket.root_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id

  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

/* Generate official Databricks root bucket policy without hardcoding AWS account IDs */
data "databricks_aws_bucket_policy" "this" {
  bucket                   = aws_s3_bucket.root_bucket.bucket
  databricks_e2_account_id = var.databricks_account_id
}

resource "aws_s3_bucket_policy" "root_bucket" {
  bucket     = aws_s3_bucket.root_bucket.id
  policy     = data.databricks_aws_bucket_policy.this.json
  depends_on = [aws_s3_bucket_public_access_block.root_bucket]
}

/* Decode Databricks STS AssumeRole policy dynamically to extract the Databricks AWS principal */
data "databricks_aws_assume_role_policy" "kms_trust" {
  provider    = databricks.mws
  external_id = var.databricks_account_id
}

locals {
  databricks_aws_principal = jsondecode(data.databricks_aws_assume_role_policy.kms_trust.json).Statement[0].Principal.AWS
}

resource "aws_kms_grant" "databricks_storage" {
  name              = "dbx-storage-grant-${aws_s3_bucket.root_bucket.bucket}"
  key_id            = var.kms_key_arn
  grantee_principal = local.databricks_aws_principal
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom",
    "ReEncryptTo",
    "CreateGrant",
    "DescribeKey"
  ]
}

resource "aws_kms_grant" "cross_account_role" {
  name              = "dbx-cross-acc-grant-${aws_s3_bucket.root_bucket.bucket}"
  key_id            = var.kms_key_arn
  grantee_principal = var.cross_account_role_arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom",
    "ReEncryptTo",
    "CreateGrant",
    "DescribeKey"
  ]
}

/* Register Customer-Managed KMS Key in Databricks MWS */
resource "databricks_mws_customer_managed_keys" "storage_cmk" {
  provider   = databricks.mws
  account_id = var.databricks_account_id
  use_cases  = ["STORAGE"]

  aws_key_info {
    key_arn = var.kms_key_arn
  }

  depends_on = [
    aws_kms_grant.databricks_storage,
    aws_kms_grant.cross_account_role
  ]
}

/* Register S3 Storage Configuration in Databricks MWS */
resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = aws_s3_bucket.root_bucket.bucket
  storage_configuration_name = var.storage_configuration_name

  depends_on = [
    aws_s3_bucket_policy.root_bucket,
    aws_s3_bucket_server_side_encryption_configuration.root_bucket
  ]
}
