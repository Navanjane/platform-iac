output "record_fqdn" {
  description = "FQDN of the DNS record"
  value       = aws_route53_record.platform.fqdn
}

output "record_name" {
  description = "Name of the DNS record"
  value       = aws_route53_record.platform.name
}
