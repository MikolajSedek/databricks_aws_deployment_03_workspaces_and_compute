/*
  Data Sources - Dev Environment
  Documentation:
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group

  Retrieves pre-existing networking infrastructure from Project 01 (Spoke VPC, Subnets, SG)
  and Databricks Account Groups established in Project 02.
*/

/* 1. Spoke VPC provisioned in Project 01 */
data "aws_vpc" "spoke" {
  filter {
    name   = "tag:Name"
    values = ["Spoke VPC-${var.environment}"]
  }
}

/* 2. Spoke Private Compute Subnets provisioned in Project 01 */
data "aws_subnets" "spoke_compute" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke.id]
  }

  filter {
    name   = "tag:Name"
    values = ["spoke-db-private-${var.environment}-*"]
  }
}

/* 3. Spoke Default Cluster Security Group provisioned in Project 01 */
data "aws_security_group" "spoke_sg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke.id]
  }

  filter {
    name   = "tag:Name"
    values = ["default_spoke_sg-${var.environment}"]
  }
}

/* 4. Databricks Account-level Groups provisioned in Project 02 */
data "databricks_group" "platform_admins" {
  provider     = databricks.mws
  display_name = "dbx-platform-admins"
}

data "databricks_group" "data_engineers" {
  provider     = databricks.mws
  display_name = "dbx-data-engineers"
}

data "databricks_group" "data_scientists" {
  provider     = databricks.mws
  display_name = "dbx-data-scientists"
}

data "databricks_group" "data_analysts" {
  provider     = databricks.mws
  display_name = "dbx-data-analysts"
}
