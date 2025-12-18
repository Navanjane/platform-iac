provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::147145168434:role/terraform-execution-role"
  }
}
