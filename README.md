# terraform-fastly-service: A fastly service with Terraform

The `terraform-fastly-service` is used to setup a [fastly service](https://docs.fastly.com/en/guides/working-with-services) 

It is based on [fastly terraform provider](https://registry.terraform.io/providers/fastly/fastly/latest/docs) and
includes an easy and fast way to generate `fastly services` with the following **features** included, in case those are
desired as well. They can be performed with simple configuration changes in the `terraform-fastly-service`:

- Fastly service with **TLS** using **AWS Route53** 
- Add Varnish Configuration Language **- VCL snippets -** to the fastly service
- Fastly service with **director**
- Fastly service with **shielding**
- Fastly service **monitoring** with **Datadog**

With parameterization of the above use cases you can get your base `fastly service` setup with several features. 

## How to use it

Once you have the `terraform-fastly-service` you need to provide the correct `credentials` for the `fastly provider` and `aws provider`

```
 export FASTLY_API_KEY="my-fastly-api-key-xxx"
 export AWS_REGION="my-aws-region"
 export AWS_ACCESS_KEY_ID="my-aws-access-key-id-xxx"
 export AWS_SECRET_ACCESS_KEY="my-aws-secret-access-key-xxx"
 export AWS_SESSION_TOKEN="my-aws-session-token-xxx"
```

Once you have set those `credentials`, let's explore the different **features provided** and how can they be performed with this module 
given the examples in [use cases examples](./use_case_examples/)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://www.terraform.io/downloads) |  1.0.6 or higher |


## Providers

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | 4.2.0 or higher|
| <a name="requirement_aws"></a> [fastly/fastly](https://registry.terraform.io/providers/fastly/fastly/1.1.0) | 1.1.0 or higher |

## Argument Reference

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domains | Internet facing CDN domains for fastly service | list | [] | yes |
| service_name       | Fastly service name | string | "" | yes | 
| director           | Backend's group director declaration. [Ref: director](https://developer.fastly.com/reference/api/load-balancing/directors/director/) | bool | false |  no |
| number_of_backends | The port number on which the backends respond | number | 1 | yes |
| port               | The port number on which the backends respond | number | 80 | yes |
| use_ssl            | Whether or not to use SSL to reach the backends | bool | false | yes |
| ssl_cert_hostname  | Overrides ssl_hostname, but only for cert verification. Does not affect SNI at all | string | "" | yes |
| ssl_check_cert     | Check SSL certs | bool | false | yes |
| ssl_sni_hostname   | Overrides ssl_hostname, but only for SNI in the handshake. Does not affect cert validation at all | string | "" | yes |  
| auto_loadbalance   | Indicates whether backend should be included in the pool of backends that requests are load balanced against | bool | false | yes | 
| max_connections    | Max connection per backend | number |1000 | yes |
| override_host      | The hostname to override the Host header | string | null | no |
| shield             | Fastly Point of Presence (POP). [Ref: shielding](https://developer.fastly.com/learning/concepts/shielding/#choosing-a-shield-location)  . If we are to use it for the fastly `image optimizer` feature for image variations | string | null | no |
| snippets           | VCL snippet's list configured for the service. [Ref: snippets](https://docs.fastly.com/en/guides/about-vcl-snippets) | list | [] | no |  
| request_settings   | Settings used to customize Fastly's request in the exposed service handling. [Ref: request settings](https://developer.fastly.com/reference/glossary/#term-request-settings-object) | list | [{ name = "force_ssl", force_ssl = true }] | no |
| logging_datadog    | Datadog configuration for fastly service monitoring integration for pushing logs if needed | list | [] | no |
| service_force_destroy      | Services that are active cannot be destroyed. In order to destroy the Service must be true, otherwise false | bool | true | yes |
| tls_certificate_authority | The entity that issues and certifies the TLS certificates | string | "lets-encrypt" | yes |
| tls_force_update          | Always update even when active domains are present | bool | true | yes |
| tls_force_destroy         | Always delete even when active domains are present. | bool | true | yes |
| route_53_record       | AWS record configuration for TLS fastly service | object | null | yes
| route_53_validation   | TLS validation in AWS for fastly service |object | null | yes |

## License

Dual-licensed under both the Magnolia Network Agreement and the GNU General Public License. See [LICENSE](./LICENSE) for full details.
