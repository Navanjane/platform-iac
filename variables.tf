variable "use_iam_role" {
  description = "Whether to use IAM role assumption. Set to false for initial bootstrap."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Root domain name for the platform (e.g., plat.devopsforge.xyz)"
  type        = string
  default     = "plat.devopsforge.xyz"
}

variable "hosted_zone_name" {
  description = "Name of the existing Route53 hosted zone"
  type        = string
  default     = "devopsforge.xyz"
}

