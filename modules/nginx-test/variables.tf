variable "release_name" {
  description = "Name of the Helm release"
  type        = string
  default     = "nginx-test"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy nginx"
  type        = string
  default     = "nginx-test"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Version of the nginx Helm chart"
  type        = string
  default     = "18.1.0"
}

variable "domain_name" {
  description = "Domain name for the ingress (optional - if empty, accessible via ALB hostname)"
  type        = string
  default     = ""
}

variable "ingress_path" {
  description = "Path for the ingress"
  type        = string
  default     = "/test"
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}

variable "alb_group_name" {
  description = "ALB group name for shared load balancer"
  type        = string
  default     = "platform-alb-dev"
}
