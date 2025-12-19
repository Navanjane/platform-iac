variable "role_name" {
  description = "Name of the Terraform execution role"
  type        = string
  default     = "terraform-execution-role"
}

variable "policy_name" {
  description = "Name of the Terraform provisioning policy"
  type        = string
  default     = "TerraformProvisioningPolicy"
}

variable "trusted_principal_arn" {
  description = "ARN of the IAM user/role that can assume the Terraform execution role"
  type        = string
  default     = "arn:aws:iam::147145168434:user/bootstrap-admin"
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Module    = "iam"
  }
}
