# Gazelle Module: A fastly service with Terraform and much more in a nutshell 

The `Gazelle terraform module` is in charge to setup a [fastly service](https://docs.fastly.com/en/guides/working-with-services) 
and more in a nutshell!

It is based on [fastly terraform provider](https://registry.terraform.io/providers/fastly/fastly/latest/docs) and
includes an easiest and fastest way to generate `fastly services` with the following **features** included, in case those are
desired too. They can be performed with simple configuration changes in the `Gazelle module`:

- Fastly service with **TLS** using **AWS Route53** 
- Add Varnish Configuration Language **- VCL snippets -** to the fastly service
- Fastly service with **director**
- Fastly service with **shielding**
- Fastly service **monitoring** with **Datadog**

Just parameterized the above use cases if needed, and you will get your `fastly service` setup and ready in a glance!!!

## How to use it

Once you have the `Gazelle module` you need to provide the correct `credentials` for the `fastly provider` and `aws provider`

```
 export FASTLY_API_KEY="my-fastly-api-key-xxx"
 export AWS_REGION="eu-central-1"
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

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| domain | Internet facing CDN domain | string | yes |
| fastly_service | Representation object that specifies a fastly service **with/without TLS, snippets, director, shielding and monitoring (datadog)** | object | yes |
| fastly_service_tls_enable_with_aws | Representation object that specifies a fastly service with TLS provided by **AWS (Route53)** setup and verification | object |  no |


### Representation Objects

    - fastly_service object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| service_name       | Fastly service name | string | "" | yes | 
| director           | Backend's group director declaration. [Ref: director](https://developer.fastly.com/reference/api/load-balancing/directors/director/) | bool | false |  yes |
| number_of_backends | The port number on which the backends respond | number | 1 | yes |
| port               | The port number on which the backends respond | number | 80 | yes |
| use_ssl            | Whether or not to use SSL to reach the backends | bool | false | yes |
| ssl_cert_hostname  | Overrides ssl_hostname, but only for cert verification. Does not affect SNI at all | string | "" | yes |
| ssl_check_cert     | Check SSL certs | bool | false | yes |
| ssl_sni_hostname   | Overrides ssl_hostname, but only for SNI in the handshake. Does not affect cert validation at all | string | "" | yes |  
| auto_loadbalance   | Indicates whether backend should be included in the pool of backends that requests are load balanced against | bool | false | yes | 
| max_connections    | Max connection per backend | number |1000 | yes |
| override_host      | The hostname to override the Host header | string | null | yes |
| shield             | Fastly Point of Presence (POP). [Ref: shielding](https://developer.fastly.com/learning/concepts/shielding/#choosing-a-shield-location)  . If we are to use it for the fastly `image optimizer` feature for image variations | string | null | yes |
| snippets           | VCL snippet's list configured for the service. [Ref: snippets](https://docs.fastly.com/en/guides/about-vcl-snippets) | list | [] | yes |  
| request_settings   | Settings used to customize Fastly's request in the exposed service handling. [Ref: request settings](https://developer.fastly.com/reference/glossary/#term-request-settings-object) | list | [] | yes |
| logging_datadog    | Datadog configuration for fastly service monitoring integration for pushing logs if needed | list | [] | yes |
| force_destroy      | Services that are active cannot be destroyed. In order to destroy the Service must be true, otherwise false | bool | true | yes |

> **TIP**: *Keep the `default values` when you define the representation object in order to **exclude/omit** certain 
> configuration (features), eg:* `override_host`, `shield` like `null` or  `snippets`,  `logging_datadog` and `request_settings` like `[]`,
>for the `fastly_service` input object variable .

    - fastly_service_tls_enable_with_aws object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| service_name       | Fastly service name | string | "" | yes | 
| enable                | Enables or not TLS for fastly_service against AWS Route53 service | bool | false | yes |
| certificate_authority | The entity that issues and certifies the TLS certificates | string | "lets-encrypt" | yes |
| force_update          | Always update even when active domains are present | bool | true | yes |
| force_destroy         | Always delete even when active domains are present. | bool | true | yes |
| route_53_record       | AWS record configuration for TLS fastly service | object | null | yes
| route_53_validation   | TLS validation in AWS for fastly service |object | null | yes |


## Attributes Reference

| Name | Description |
|------|-------------|
| cdn_url | CDN endpoint for the fastly service created |
| service_id | Fastly service identifier |


## License

Dual-licensed under both the Magnolia Network Agreement and the GNU General Public License. See [LICENSE](./LICENSE) for full details.




   