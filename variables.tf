variable "use_iam_role" {
  description = "Whether to use IAM role assumption. Set to false for initial bootstrap."
  type        = bool
  default     = false
}
