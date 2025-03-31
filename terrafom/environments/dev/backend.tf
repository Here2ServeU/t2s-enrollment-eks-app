terraform {
  backend "s3" {
    bucket         = "t2s-enrollment-tf-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "t2s-enrollment-tf-lock"
  }
}
