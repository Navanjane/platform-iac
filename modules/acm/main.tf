# ACM Certificate for HTTPS/TLS
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name        = var.domain_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )
}

# DNS Validation Records in Route53
# Only created if skip_dns_validation = false
resource "aws_route53_record" "cert_validation" {
  for_each = var.skip_dns_validation ? {} : {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# Wait for Certificate Validation to Complete
# Only wait if automatic validation is enabled (skip_dns_validation = false)
resource "aws_acm_certificate_validation" "main" {
  count = var.skip_dns_validation ? 0 : 1

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  timeouts {
    create = "15m"
  }
}
