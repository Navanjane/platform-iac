variable "use_iam_role" {
  description = "Whether to use IAM role assumption. Set to false for initial bootstrap."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for the platform (e.g., example.com)"
  type        = string
  default     = "yourdomain.com"
}
