variable "domain_name" {
  description = "Primary domain name for the certificate (e.g., argocd.example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names to include in the certificate (SANs)"
  type        = list(string)
  default     = []
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for DNS validation (optional - only needed if skip_dns_validation = false)"
  type        = string
  default     = ""
}

variable "skip_dns_validation" {
  description = "Skip automatic DNS validation via Route53 (set true if DNS managed externally like Vercel)"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
