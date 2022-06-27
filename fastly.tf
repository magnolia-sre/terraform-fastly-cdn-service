locals {
  host     = regex("[^\\.]*", var.domains[0])
  backends = [for i in range(0, var.number_of_backends) : "backend_${i}"]
  director = var.director ? toset(formatlist(local.host)) : []
}

resource "fastly_service_vcl" "service" {
  name = var.service_name

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
      address           = var.backend_address
      name              = backend.value
      port              = var.port
      use_ssl           = var.use_ssl
      ssl_cert_hostname = var.ssl_cert_hostname
      ssl_check_cert    = var.ssl_check_cert
      ssl_sni_hostname  = var.ssl_sni_hostname
      auto_loadbalance  = var.auto_loadbalance
      max_conn          = var.max_connections
      override_host     = var.override_host
      shield            = var.shield
    }
  }

  dynamic "snippet" {
    for_each = var.snippets
    content {
      name     = snippet.value.name
      type     = snippet.value.type
      priority = snippet.value.priority
      content  = snippet.value.content
    }
  }

  dynamic "domain" {
    for_each = var.domains

    content {
      name    = domain.value
      comment = "${domain.value} service domain"
    }
  }

  dynamic "request_setting" {
    for_each = var.request_settings
    content {
      name      = request_setting.value.name
      force_ssl = request_setting.value.force_ssl
    }
  }

  dynamic "logging_datadog" {
    for_each = var.logging_datadog
    content {
      name   = logging_datadog.value.name
      token  = logging_datadog.value.token
      region = logging_datadog.value.region
      format = templatefile("${path.module}/monitoring/datadog/access_log_format_fastly.tpl", { service_name = format("fastly-%s", local.host) })
    }
  }

  force_destroy = var.service_force_destroy
}