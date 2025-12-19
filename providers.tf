provider "aws" {
  region = "us-east-1"

  # Conditionally assume role based on TF_VAR_use_iam_role environment variable
  # Set TF_VAR_use_iam_role=false for bootstrapping (initial deployment)
  # Set TF_VAR_use_iam_role=true for normal operations (default)
  dynamic "assume_role" {
    for_each = var.use_iam_role ? [1] : []
    content {
      role_arn = "arn:aws:iam::147145168434:role/terraform-execution-role"
    }
  }
}
