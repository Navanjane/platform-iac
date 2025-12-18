provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::<ACCOUNT_ID>:role/terraform-execution-role"
  }
}
