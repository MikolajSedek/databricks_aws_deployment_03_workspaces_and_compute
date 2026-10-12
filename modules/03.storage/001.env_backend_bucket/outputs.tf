/*
  Output Values - S3 Backend Bucket Module
  Documentation: https://developer.hashicorp.com/terraform/language/values/outputs
*/

output "bucket_name" {
  description = "The name of the remote state backend S3 bucket."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "The ARN of the remote state backend S3 bucket."
  value       = aws_s3_bucket.this.arn
}
