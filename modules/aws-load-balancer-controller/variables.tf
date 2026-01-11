variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID where the cluster is deployed"
  type        = string
  default     = ""
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  type        = string
  default     = ""
}

variable "oidc_provider" {
  description = "OIDC provider URL for the EKS cluster (without https://)"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "chart_version" {
  description = "Version of the AWS Load Balancer Controller Helm chart"
  type        = string
  default     = "1.11.0"
}

variable "enable_shield" {
  description = "Enable AWS Shield integration"
  type        = bool
  default     = false
}

variable "enable_waf" {
  description = "Enable AWS WAF integration"
  type        = bool
  default     = false
}

variable "enable_wafv2" {
  description = "Enable AWS WAFv2 integration"
  type        = bool
  default     = false
}

variable "resources_limits_cpu" {
  description = "CPU limit for the controller"
  type        = string
  default     = "200m"
}

variable "resources_limits_memory" {
  description = "Memory limit for the controller"
  type        = string
  default     = "500Mi"
}

variable "resources_requests_cpu" {
  description = "CPU request for the controller"
  type        = string
  default     = "100m"
}

variable "resources_requests_memory" {
  description = "Memory request for the controller"
  type        = string
  default     = "200Mi"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
