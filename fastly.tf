locals {
  host     = regex("[^\\.]*", var.domain)
  backends = [for i in range(0, var.fastly_service.number_of_backends) : "backend_${i}"]
  director = var.fastly_service.director ? toset(formatlist(local.host)) : []
}

resource "fastly_service_vcl" "service" {
  name = var.fastly_service.service_name

  dynamic "director" {
    for_each = local.director
    content {
      backends = local.backends
      name     = replace(local.host, "-", "_") # Director name allow dashes but the VCL that refers this director name does not allow it for its own logic.
    }
  }

  dynamic "backend" {
    for_each = local.backends
    content {
      address           = var.fastly_service.backend_address
      name              = backend.value
      port              = var.fastly_service.port
      use_ssl           = var.fastly_service.use_ssl
      ssl_cert_hostname = var.fastly_service.ssl_cert_hostname
      ssl_check_cert    = var.fastly_service.ssl_check_cert
      ssl_sni_hostname  = var.fastly_service.ssl_sni_hostname
      auto_loadbalance  = var.fastly_service.auto_loadbalance
      max_conn          = var.fastly_service.max_connections
      override_host     = var.fastly_service.override_host
      shield            = var.fastly_service.shield
    }
  }

  dynamic "snippet" {
    for_each = var.fastly_service.snippets
    content {
      name     = snippet.value.name
      type     = snippet.value.type
      priority = snippet.value.priority
      content  = snippet.value.content
    }
  }

  domain {
    name    = var.domain
    comment = "${var.domain} service domain"
  }

  dynamic "request_setting" {
    for_each = var.fastly_service.request_settings
    content {
      name      = request_setting.value.name
      force_ssl = request_setting.value.force_ssl
    }
  }

  dynamic "logging_datadog" {
    for_each = var.fastly_service.logging_datadog
    content {
      name   = logging_datadog.value.name
      token  = logging_datadog.value.token
      region = logging_datadog.value.region
      format = templatefile("monitoring/datadog/access_log_format_fastly.tpl", { service_name = format("fastly-%s", local.host) })
    }
  }

  force_destroy = var.fastly_service.force_destroy
}