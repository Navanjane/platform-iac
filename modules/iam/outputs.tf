output "terraform_role_arn" {
  description = "ARN of the Terraform execution role"
  value       = aws_iam_role.terraform.arn
}

output "terraform_role_name" {
  description = "Name of the Terraform execution role"
  value       = aws_iam_role.terraform.name
}

output "terraform_policy_arn" {
  description = "ARN of the Terraform provisioning policy"
  value       = aws_iam_policy.terraform_policy.arn
}
