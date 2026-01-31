variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the CNAME record (e.g., plat.devopsforge.xyz)"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS hostname to point the CNAME record to"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
