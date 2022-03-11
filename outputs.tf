output "cdn_url" {
  value = "https://${var.domain}"
}

output "service_id" {
  value = fastly_service_vcl.service.id
}