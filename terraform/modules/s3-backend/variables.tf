variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
}