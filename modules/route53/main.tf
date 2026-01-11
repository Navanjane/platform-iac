# Route53 Hosted Zone for DNS Management
resource "aws_route53_zone" "main" {
  name          = var.domain_name
  comment       = "Managed by Terraform for ${var.environment} environment"
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name        = var.domain_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Purpose     = "Platform DNS"
    }
  )
}
