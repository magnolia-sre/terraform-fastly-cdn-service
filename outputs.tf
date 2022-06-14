output "cdn_url" {
  description = "The internet-facing endpoint created for the fastly service created"
  value = "https://${var.domain}"
}

output "service_id" {
  description = "The fastly service identifier created"
  value = fastly_service_vcl.service.id
}