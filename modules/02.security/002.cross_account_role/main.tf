/*
  Databricks Cross-Account IAM Role and MWS Credentials Configuration
  Documentation:
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_assume_role_policy
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_crossaccount_policy
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_credentials
*/

/* 1. Generate Databricks STS AssumeRole trust policy via official Databricks data source */
data "databricks_aws_assume_role_policy" "this" {
  provider    = databricks.mws
  external_id = var.databricks_account_id
}

/* 2. Generate Databricks cross-account permissions policy via official Databricks data source */
data "databricks_aws_crossaccount_policy" "this" {
  policy_type = "customer"
}

/* 3. AWS IAM Role using Databricks assume role trust policy */
resource "aws_iam_role" "cross_account_role" {
  name               = var.role_name
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = var.tags
}

/* 4. AWS IAM Role Policy attaching official Databricks cross-account permissions */
resource "aws_iam_role_policy" "cross_account_policy" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}

/*
  5. Wait 30 seconds for IAM role and policy eventual consistency propagation across AWS STS endpoints
  before attempting registration in the Databricks Account console.
*/
resource "time_sleep" "wait_for_role_propagation" {
  depends_on      = [aws_iam_role_policy.cross_account_policy]
  create_duration = "30s"
}

/* 6. Register credentials in Databricks MWS Account console */
resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  credentials_name = var.credentials_name
  role_arn         = aws_iam_role.cross_account_role.arn

  depends_on = [time_sleep.wait_for_role_propagation]
}
