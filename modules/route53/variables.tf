variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "force_destroy" {
  description = "Allow destruction of the hosted zone even if it contains records"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
