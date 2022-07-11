output "certificate_id" {
  value = one(aws_acm_certificate.cert.*.id)
}

output "certificate_arn" {
  value = one(aws_acm_certificate.cert.*.arn)
}

output "certificate_domain_name" {
  value = one(aws_acm_certificate.cert.*.domain_name)
}

output "certificate_status" {
  value = one(aws_acm_certificate.cert.*.status)
}