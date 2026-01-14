variable "use_iam_role" {
  description = "Whether to use IAM role assumption. Set to false for initial bootstrap."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Root domain name for the platform (e.g., plat.navanjane.com)"
  type        = string
  default     = "plat.navanjane.com"
}

