variable "namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Version of the ArgoCD Helm chart"
  type        = string
  default     = "3.2.3"
}

variable "release_name" {
  description = "Helm release name for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "values_file" {
  description = "Path to custom values file (optional)"
  type        = string
  default     = ""
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

# Ingress Configuration
variable "enable_ingress" {
  description = "Enable Kubernetes Ingress for ArgoCD (uses ALB)"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for ArgoCD (e.g., argocd.yourdomain.com)"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for DNS record creation"
  type        = string
  default     = ""
}

variable "create_dns_record" {
  description = "Whether to create Route53 DNS record automatically"
  type        = bool
  default     = true
}

variable "alb_group_name" {
  description = "ALB group name for sharing ALB across multiple ingresses"
  type        = string
  default     = "platform-alb"
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB for Route53 alias record (us-east-1: Z35SXDOTRQ7X7K)"
  type        = string
  default     = "Z35SXDOTRQ7X7K"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
