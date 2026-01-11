output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.main.arn
}

output "certificate_domain_name" {
  description = "Domain name of the certificate"
  value       = aws_acm_certificate.main.domain_name
}

output "certificate_status" {
  description = "Status of the certificate (should be ISSUED after validation)"
  value       = aws_acm_certificate.main.status
}

output "validation_complete" {
  description = "ID indicating certificate validation is complete (only available with automatic validation)"
  value       = length(aws_acm_certificate_validation.main) > 0 ? aws_acm_certificate_validation.main[0].id : "manual-validation-required"
}

output "dns_validation_records" {
  description = "DNS validation records - ADD THESE TO VERCEL DNS"
  value = [
    for dvo in aws_acm_certificate.main.domain_validation_options : {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  ]
}
