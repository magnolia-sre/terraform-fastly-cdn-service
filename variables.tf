variable "domain" {
  type        = string
  description = "Fastly service domain"
}

variable "fastly_service" {
  description = <<EOF
    service_name       = Fastly service name
    director           = Backend's group director declaration. Ref t.ly/ZT0jG
    backend_address    = Backend host address
    number_of_backends = The port number on which the backends respond
    port               = The port number on which the backends respond
    use_ssl            = Whether or not to use SSL to reach the backends
    ssl_cert_hostname  = Overrides ssl_hostname, but only for cert verification. Does not affect SNI at all
    ssl_check_cert     = Check SSL certs
    ssl_sni_hostname   = Overrides ssl_hostname, but only for SNI in the handshake. Does not affect cert validation at all
    auto_loadbalance   = Indicates whether backend should be included in the pool of backends that requests are load balanced against
    max_connections    = Max connection per backend
    override_host      = The hostname to override the Host header
    shield             = Fastly Point of Presence (POP). Ref: t.ly/RN82 . If we are to use it for the fastly `image optimizer` feature for image variations
    snippets           = VCL snippet's list configured for the service. Ref t.ly/vX8c
    request_settings   = Settings used to customize Fastly's request in the exposed service handling. Ref: t.ly/gsyr
    logging_datadog    = Datadog configuration for fastly service monitoring integration for pushing logs if needed
    force_destroy      = Services that are active cannot be destroyed. In order to destroy the Service must be true, otherwise false
  EOF
  type = object({
    service_name       = string
    director           = bool
    backend_address    = string
    number_of_backends = number
    port               = number
    use_ssl            = bool
    ssl_cert_hostname  = string
    ssl_check_cert     = bool
    ssl_sni_hostname   = string
    auto_loadbalance   = bool
    max_connections    = number
    override_host      = string
    shield             = string
    snippets = list(object({
      name     = string
      type     = string
      priority = number
      content  = string
    }))
    request_settings = list(object({
      name      = string
      force_ssl = bool
    }))
    logging_datadog = list(object({
      name   = string
      token  = string
      region = string
    }))
    force_destroy = bool
  })
  default = {
    service_name       = ""
    director           = false
    backend_address    = ""
    number_of_backends = 1
    port               = 80
    use_ssl            = false
    ssl_cert_hostname  = ""
    ssl_check_cert     = false
    ssl_sni_hostname   = ""
    auto_loadbalance   = false
    max_connections    = 1000
    override_host      = null
    shield             = null
    snippets           = []
    request_settings   = []
    logging_datadog    = []
    force_destroy      = true
  }
}

variable "fastly_service_tls_enable_with_aws" {
  description = <<EOF
    enable                = Enables or not TLS for fastly_service against AWS Route53 service
    certificate_authority = The entity that issues and certifies the TLS certificates
    force_update          = Always update even when active domains are present
    force_destroy         = Always delete even when active domains are present.
    route_53_record       = AWS record configuration for TLS fastly service
    route_53_validation   = TLS validation in AWS for fastly service
  EOF
  type = object({
    enable                = bool
    certificate_authority = string
    force_update          = bool
    force_destroy         = bool
    route_53_record = object({
      type = string
      ttl  = number
    })
    route_53_validation = object({
      allow_overwrite = bool
      ttl             = number
    })
  })
  default = {
    enable                = false
    certificate_authority = "lets-encrypt"
    force_update          = true
    force_destroy         = true
    route_53_record       = null
    route_53_validation   = null
  }
}





