# IAM Module
# This module creates the Terraform execution role and associated policies
# for infrastructure provisioning.

# Trust policy document for the Terraform execution role
data "aws_iam_policy_document" "terraform_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Terraform execution role
resource "aws_iam_role" "terraform" {
  name                 = var.role_name
  assume_role_policy   = data.aws_iam_policy_document.terraform_trust.json
  max_session_duration = 7200  # 2 hours - matches GitHub Actions workflow

  tags = merge(var.tags, {
    Purpose = "Terraform provisioning"
  })
}

# Terraform provisioning policy
resource "aws_iam_policy" "terraform_policy" {
  name = var.policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "eks:*",
          "iam:*",
          "autoscaling:*",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "logs:*",
          "s3:*",
          "dynamodb:*",
          "kms:*",
          "ssm:*",
          "route53:*",
          "acm:*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "terraform_attach" {
  role       = aws_iam_role.terraform.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}

# Policy to allow bootstrap-admin user to assume the terraform execution role
resource "aws_iam_user_policy" "bootstrap_assume_role" {
  name = "AssumeTeraformExecutionRole"
  user = "bootstrap-admin"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.terraform.arn
      }
    ]
  })
}
