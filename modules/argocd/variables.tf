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
