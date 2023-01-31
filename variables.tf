variable "domains" {
  type        = list(string)
  description = "Fastly service domains"
  default     = []
}

variable "service_name" {
  description = "Fastly service name"
  type        = string
  default     = ""
}

variable "director" {
  description = "Backend's group director declaration. Ref t.ly/ZT0jG"
  type        = bool
  default     = false
}

variable "backend_address" {
  description = "Backend host address"
  type        = string
  default     = ""
}

variable "number_of_backends" {
  description = "The port number on which the backends respond"
  type        = number
  default     = 1
}

variable "port" {
  description = "The port number on which the backends respond"
  type        = number
  default     = 80
}

variable "use_ssl" {
  description = "Whether or not to use SSL to reach the backends"
  type        = bool
  default     = false
}

variable "ssl_cert_hostname" {
  description = "Overrides ssl_hostname, but only for cert verification. Does not affect SNI at all"
  type        = string
  default     = ""
}

variable "ssl_check_cert" {
  description = "Check SSL certs"
  type        = bool
  default     = false
}

variable "ssl_sni_hostname" {
  description = "Overrides ssl_hostname, but only for SNI in the handshake. Does not affect cert validation at all"
  type        = string
  default     = ""
}

variable "auto_loadbalance" {
  description = "Indicates whether backend should be included in the pool of backends that requests are load balanced against"
  type        = bool
  default     = false
}

variable "max_connections" {
  description = "Max connection per backend"
  type        = number
  default     = 1000
}

variable "override_host" {
  description = "The hostname to override the Host header"
  type        = string
  default     = null
}

variable "shield" {
  description = "Fastly Point of Presence (POP). Ref: t.ly/RN82 . If we are to use it for the fastly `image optimizer` feature for image variations"
  type        = string
  default     = null
}

variable "snippets" {
  description = "VCL snippet's list configured for the service. Ref t.ly/vX8c"
  type = list(object({
    name     = string
    type     = string
    priority = number
    content  = string
  }))
  default = []
}

variable "request_settings" {
  description = "Settings used to customize Fastly's request in the exposed service handling. Ref: t.ly/gsyr"
  type = list(object({
    name      = string
    force_ssl = bool
  }))
  default = [
    {
      name      = "force_ssl"
      force_ssl = true
    }
  ]
}

variable "logging_datadog" {
  description = "Datadog configuration for fastly service monitoring integration for pushing logs if needed"
  type = list(object({
    name   = string
    token  = string
    region = string
    format = optional(string)
  }))
  default = []
}

variable "service_force_destroy" {
  description = "Services that are active cannot be destroyed. In order to destroy the Service must be true, otherwise false"
  type        = bool
  default     = true
}

variable "tls_certificate_authority" {
  description = "The entity that issues and certifies the TLS certificates"
  type        = string
  default     = "lets-encrypt"
}

variable "tls_force_update" {
  description = "Always update even when active domains are present"
  type        = bool
  default     = true
}

variable "tls_force_destroy" {
  description = "Always delete even when active domains are present"
  type        = bool
  default     = true
}

variable "aws_route_53_record" {
  description = "AWS record configuration for TLS fastly service"
  type = object({
    type = string
    ttl  = number
  })
  default = null
}

variable "aws_route_53_validation" {
  description = "TLS validation in AWS for fastly service"
  type = object({
    allow_overwrite = bool
    ttl             = number
  })
  default = null
}
