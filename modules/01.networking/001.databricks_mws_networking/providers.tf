/*
  Terraform, AWS, and Databricks Provider Configuration - MWS Networking Module
  Documentation:
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs

  Declares required Terraform version, AWS provider, and Databricks provider constraints with MWS alias.
*/

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    databricks = {
      source                = "databricks/databricks"
      version               = ">= 1.135.0"
      configuration_aliases = [databricks.mws]
    }
  }
}
