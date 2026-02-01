variable "namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Version of the ArgoCD Helm chart"
  type        = string
  default     = "7.8.0" # Updated from 3.2.3 - values structure may differ
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
  description = "Root domain name for the platform (e.g., plat.navanjane.com)"
  type        = string
  default     = ""
}

variable "ingress_path" {
  description = "Path for ArgoCD ingress"
  type        = string
  default     = "/"
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
  default     = ""
}

variable "alb_group_name" {
  description = "ALB group name for sharing ALB across multiple ingresses"
  type        = string
  default     = "platform-alb"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
