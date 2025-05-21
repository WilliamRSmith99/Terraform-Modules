

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_command"></a> [command](#requirement\_command) | ~> 0.1 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 5.0 |
| <a name="requirement_onepassword"></a> [onepassword](#requirement\_onepassword) | ~> 1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |
| <a name="requirement_teleport"></a> [teleport](#requirement\_teleport) | ~> 14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 5.0 |
| <a name="provider_oci.region1"></a> [oci.region1](#provider\_oci.region1) | ~> 5.0 |
| <a name="provider_onepassword"></a> [onepassword](#provider\_onepassword) | ~> 1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kasm_agents"></a> [kasm\_agents](#module\_kasm\_agents) | ./modules/instance | n/a |
| <a name="module_kasm_cpx"></a> [kasm\_cpx](#module\_kasm\_cpx) | ./modules/autoscale_instance | n/a |
| <a name="module_kasm_webapps"></a> [kasm\_webapps](#module\_kasm\_webapps) | ./modules/autoscale_instance | n/a |
| <a name="module_one_password_upload"></a> [one\_password\_upload](#module\_one\_password\_upload) | ./modules/1Password | n/a |
| <a name="module_region1_kasm_agents"></a> [region1\_kasm\_agents](#module\_region1\_kasm\_agents) | ./modules/instance | n/a |
| <a name="module_region1_kasm_cpx"></a> [region1\_kasm\_cpx](#module\_region1\_kasm\_cpx) | ./modules/autoscale_instance | n/a |
| <a name="module_region1_kasm_proxy"></a> [region1\_kasm\_proxy](#module\_region1\_kasm\_proxy) | ./modules/autoscale_instance | n/a |
| <a name="module_region1_op_upload"></a> [region1\_op\_upload](#module\_region1\_op\_upload) | ./modules/1Password | n/a |
| <a name="module_teleport_join_token"></a> [teleport\_join\_token](#module\_teleport\_join\_token) | ./modules/teleport | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_images.management_image](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_images.region1_image](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_network_security_groups.management_network_security_groups](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_network_security_groups) | data source |
| [oci_core_network_security_groups.region1_network_security_groups](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_network_security_groups) | data source |
| [oci_core_subnets.management_subnets](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_subnets) | data source |
| [oci_core_subnets.region1_subnets](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_subnets) | data source |
| [oci_core_vcns.management_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_vcns) | data source |
| [oci_core_vcns.region1_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_vcns) | data source |
| [oci_dns_rrsets.records](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/dns_rrsets) | data source |
| [oci_dns_zones.zone](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/dns_zones) | data source |
| [oci_identity_availability_domains.management_ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_availability_domains.region1_ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_compartments.compartment](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartments) | data source |
| [oci_identity_compartments.image](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartments) | data source |
| [oci_identity_tenancy.image](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tenancy) | data source |
| [oci_identity_user.kasm_user](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_user) | data source |
| [oci_kms_keys.management_keys](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/kms_keys) | data source |
| [oci_kms_keys.region1_keys](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/kms_keys) | data source |
| [oci_kms_vaults.management_vault](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/kms_vaults) | data source |
| [oci_kms_vaults.region1_vault](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/kms_vaults) | data source |
| [oci_load_balancer_backend_sets.management_backend_sets](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/load_balancer_backend_sets) | data source |
| [oci_load_balancer_backend_sets.region1_backend_sets](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/load_balancer_backend_sets) | data source |
| [oci_load_balancers.management_lbs](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/load_balancers) | data source |
| [oci_load_balancers.region1_lbs](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/load_balancers) | data source |
| [onepassword_item.secret](https://registry.terraform.io/providers/1Password/onepassword/latest/docs/data-sources/item) | data source |
| [onepassword_vault.this](https://registry.terraform.io/providers/1Password/onepassword/latest/docs/data-sources/vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_additional_install_arguments"></a> [agent\_additional\_install\_arguments](#input\_agent\_additional\_install\_arguments) | Additional arguments to send to the Kasm agent for advanced installations | `string` | `"-O"` | no |
| <a name="input_agent_vm_settings"></a> [agent\_vm\_settings](#input\_agent\_vm\_settings) | Agent VM settings | <pre>object({<br>    instance_state        = string<br>    shape                 = string<br>    disk_size_in_gbs      = number<br>    disk_vpus             = number<br>    memory_in_gbs         = number<br>    cpus                  = number<br>    in_transit_encryption = bool<br>    utilization           = string<br>    enable_imdsv2         = bool<br>    backup_policy         = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_api_private_key_path"></a> [api\_private\_key\_path](#input\_api\_private\_key\_path) | OCI User API private key file | `string` | n/a | yes |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS Access Key ID value used in lieu of environment variable-based AWS authentication | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region where you wish to create the Kasm DNS zone | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS Secret Key value used in lieu of environment variable-based AWS authentication | `string` | `""` | no |
| <a name="input_compartment_name"></a> [compartment\_name](#input\_compartment\_name) | The name of the new Kasm compartment | `string` | n/a | yes |
| <a name="input_cpx_additional_install_arguments"></a> [cpx\_additional\_install\_arguments](#input\_cpx\_additional\_install\_arguments) | Additional arguments to send to the Kasm Connection Proxy (CPX) for advanced installations | `string` | `"-O"` | no |
| <a name="input_cpx_autoscale_config"></a> [cpx\_autoscale\_config](#input\_cpx\_autoscale\_config) | OCI Autoscale configuration for Kasm Connection Proxy (CPX) servers | <pre>map(object({<br>    config_name = string<br>    policy_type = string<br>    policy_name = string<br>    is_enabled  = bool<br>    min_size    = number<br>    max_size    = number<br>  }))</pre> | n/a | yes |
| <a name="input_cpx_vm_settings"></a> [cpx\_vm\_settings](#input\_cpx\_vm\_settings) | Kasm Connection Proxy (CPX) VM settings | <pre>object({<br>    shape                 = string<br>    disk_size_in_gbs      = number<br>    memory_in_gbs         = number<br>    disk_vpus             = number<br>    cpus                  = number<br>    utilization           = string<br>    recovery_action       = string<br>    maintenance_action    = string<br>    in_transit_encryption = bool<br>    enable_imdsv2         = bool<br>    live_migrate          = bool<br>    num_instances         = number<br>  })</pre> | n/a | yes |
| <a name="input_customer_managed_keys"></a> [customer\_managed\_keys](#input\_customer\_managed\_keys) | Use Customer Managed KMS keys to encrypt Object buckets | `bool` | `false` | no |
| <a name="input_customer_name"></a> [customer\_name](#input\_customer\_name) | The full name of the new Kasm Customer | `string` | n/a | yes |
| <a name="input_database_ip"></a> [database\_ip](#input\_database\_ip) | Kasm Database IP address or hostname | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Default Defined tags to add to the Terraform-deployed resources | `map(any)` | `null` | no |
| <a name="input_deploy_nfs"></a> [deploy\_nfs](#input\_deploy\_nfs) | true makes Kasm agents sit behind the NAT Gateway | `bool` | `false` | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | The type of deployment to build. Acceptable values are blue or green. | `string` | n/a | yes |
| <a name="input_deployment_strategy"></a> [deployment\_strategy](#input\_deployment\_strategy) | The type of deployment to build. Acceptable values are blue-green, or rolling. | `list(string)` | <pre>[<br>  "Blue",<br>  "Green"<br>]</pre> | no |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | Type of Kasm deployment | `string` | n/a | yes |
| <a name="input_enable_gpu"></a> [enable\_gpu](#input\_enable\_gpu) | Whether or not to install GPU libraries on the Kasm Agent | `bool` | `false` | no |
| <a name="input_enable_grafana"></a> [enable\_grafana](#input\_enable\_grafana) | Enable log forwarding to Grafana | `bool` | `true` | no |
| <a name="input_enable_sysbox"></a> [enable\_sysbox](#input\_enable\_sysbox) | Enable Sysbox on Agents for Sudo privileges. | `bool` | `false` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | OCI User Private API key fingerprint value | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Default tags to add to Terraform-deployed Kasm services | `map(any)` | `null` | no |
| <a name="input_grafana_password"></a> [grafana\_password](#input\_grafana\_password) | The API Password Credential to forward Kasm logs to Grafana | `string` | `""` | no |
| <a name="input_grafana_username"></a> [grafana\_username](#input\_grafana\_username) | The API User Credential to forward Kasm logs to Grafana | `string` | `""` | no |
| <a name="input_image_compartment_name"></a> [image\_compartment\_name](#input\_image\_compartment\_name) | The name of the new Kasm compartment | `string` | `"customer_deployments"` | no |
| <a name="input_image_type"></a> [image\_type](#input\_image\_type) | The image type to use, whether the default maintainer version, or the kasm pre-built image. | `string` | n/a | yes |
| <a name="input_instance_principal"></a> [instance\_principal](#input\_instance\_principal) | Use OCI Instance Principal to authenticate instead of user-based API credentials | `string` | n/a | yes |
| <a name="input_is_child_compartment"></a> [is\_child\_compartment](#input\_is\_child\_compartment) | Is the compartment used for this deployment a child of any other compartments (including the tenancy)? | `bool` | `true` | no |
| <a name="input_kasm_database_password"></a> [kasm\_database\_password](#input\_kasm\_database\_password) | The password for the database. No special characters | `string` | `""` | no |
| <a name="input_kasm_domain_name"></a> [kasm\_domain\_name](#input\_kasm\_domain\_name) | The domain name to use for your Kasm deployment - used when creating a new DNS zone | `string` | n/a | yes |
| <a name="input_kasm_download_url"></a> [kasm\_download\_url](#input\_kasm\_download\_url) | The URL for the Kasm Workspaces build | `string` | n/a | yes |
| <a name="input_kasm_manager_token"></a> [kasm\_manager\_token](#input\_kasm\_manager\_token) | The manager token value for Agents to authenticate to webapps. No special characters | `string` | `""` | no |
| <a name="input_kasm_redis_password"></a> [kasm\_redis\_password](#input\_kasm\_redis\_password) | The password for the Redis server. No special characters | `string` | `""` | no |
| <a name="input_kasm_service_token"></a> [kasm\_service\_token](#input\_kasm\_service\_token) | The service registration token value for Guac RDP servers to authenticate to webapps. No special characters | `string` | `""` | no |
| <a name="input_kasm_version"></a> [kasm\_version](#input\_kasm\_version) | Kasm version to deploy | `string` | n/a | yes |
| <a name="input_monitoring_domain"></a> [monitoring\_domain](#input\_monitoring\_domain) | Deployment domain name to register with Monitoring agent | `string` | `""` | no |
| <a name="input_nfs_profile_path"></a> [nfs\_profile\_path](#input\_nfs\_profile\_path) | The NFS export mount path for persistent profiles | `string` | `"/kasm/profiles"` | no |
| <a name="input_nginx_cert"></a> [nginx\_cert](#input\_nginx\_cert) | Nginx certificate to upload to Agent | `string` | `""` | no |
| <a name="input_nginx_key"></a> [nginx\_key](#input\_nginx\_key) | Nginx private key to upload to Agent | `string` | `""` | no |
| <a name="input_number_of_kasm_agents"></a> [number\_of\_kasm\_agents](#input\_number\_of\_kasm\_agents) | The number of static Kasm agents to deploy | `number` | n/a | yes |
| <a name="input_oci_region_to_kasm_zone_map"></a> [oci\_region\_to\_kasm\_zone\_map](#input\_oci\_region\_to\_kasm\_zone\_map) | OCI Region mapped to associated Kasm zone name | `map(string)` | <pre>{<br>  "af-johannesburg-1": "S-Africa-(Johannesburg)",<br>  "ap-chuncheon-1": "S-Korea-(Chuncheon)",<br>  "ap-hyderbad-1": "India-(Hyderbad)",<br>  "ap-melbourne-1": "Australia-(Melbourne)",<br>  "ap-mumbai-1": "India-(Mumbai)",<br>  "ap-osaka-1": "Japan-(Osaka)",<br>  "ap-seoul-1": "S-Korea-(Seoul)",<br>  "ap-singapore-1": "Asia-(Singapore)",<br>  "ap-sydney-1": "Australia-(Sydney)",<br>  "ap-tokyo-1": "Japan-(Tokyo)",<br>  "ca-montreal-1": "Canada-(Montreal)",<br>  "ca-toronto-1": "Canada-(Toronto)",<br>  "eu-amsterdam-1": "Netherlands-(Amsterdam)",<br>  "eu-frankfurt-1": "Germany-(Frankfurt)",<br>  "eu-jovanovac-1": "Servia-(Jovanovac)",<br>  "eu-madrid-1": "Spani-(Madrid)",<br>  "eu-marseille-1": "France-(Marseille)",<br>  "eu-milan-1": "Italy-(Milan)",<br>  "eu-paris-1": "France-(Paris)",<br>  "eu-stockholm-1": "Sweden-(Stockholm)",<br>  "eu-zurich-1": "Switzerland-(Zurich)",<br>  "il-jerusalem-1": "Israel-(Jerusalem)",<br>  "me-abudhabi-1": "UAE-(Abu-Dhabi)",<br>  "me-dubai-1": "UAE-(Dubai)",<br>  "me-jeddah-1": "Saudi-Arabia-(Jeddah)",<br>  "mx-monterrey-1": "Mexico-(Monterrey)",<br>  "mx-queretaro-1": "Mexico-(Queretaro)",<br>  "sa-santiago-1": "Chile-(Santiago)",<br>  "sa-saopaulo-1": "Brazil-(Sao-Paulo)",<br>  "sa-vinhedo-1": "Brazil-(Vinhedo)",<br>  "uk-cardiff-1": "UK-(Cardiff)",<br>  "uk-london-1": "UK-(London)",<br>  "us-ashburn-1": "USA-(Virginia)",<br>  "us-chicago-1": "USA-(Illinois)",<br>  "us-phoenix-1": "USA-(Arizona)",<br>  "us-sanjose-1": "USA-(California)"<br>}</pre> | no |
| <a name="input_oci_regions"></a> [oci\_regions](#input\_oci\_regions) | OCI Region where you wish to install Kasm | `list(string)` | n/a | yes |
| <a name="input_one_password_tags"></a> [one\_password\_tags](#input\_one\_password\_tags) | Organization Tags associated with 1Pass secret | `list(string)` | `[]` | no |
| <a name="input_one_password_token"></a> [one\_password\_token](#input\_one\_password\_token) | Authentication token for 1Password Connect Server | `string` | n/a | yes |
| <a name="input_one_password_url"></a> [one\_password\_url](#input\_one\_password\_url) | URL of the 1Password Connect server | `string` | `"https://1password.kasmweb.io"` | no |
| <a name="input_one_password_vault"></a> [one\_password\_vault](#input\_one\_password\_vault) | The 1Password vault to inject/retrieve secrets from | `string` | `"Customer-Deployments"` | no |
| <a name="input_parent_domain_name"></a> [parent\_domain\_name](#input\_parent\_domain\_name) | The Parent (or root) domain name to use for your Kasm deployment - used when adding DNS zone NS records to the Parent zone | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Value to use for VCN prefix to make it unique. Usually a customer name (or customer short name). | `string` | n/a | yes |
| <a name="input_proxy_additional_install_arguments"></a> [proxy\_additional\_install\_arguments](#input\_proxy\_additional\_install\_arguments) | Additional arguments to send to the Kasm Proxy-only nodes for advanced installations | `string` | `"-O"` | no |
| <a name="input_proxy_autoscale_config"></a> [proxy\_autoscale\_config](#input\_proxy\_autoscale\_config) | OCI Autoscale configuration for Kasm Proxy-only nodes servers | <pre>map(object({<br>    config_name = string<br>    policy_type = string<br>    policy_name = string<br>    is_enabled  = bool<br>    min_size    = number<br>    max_size    = number<br>  }))</pre> | n/a | yes |
| <a name="input_proxy_vm_settings"></a> [proxy\_vm\_settings](#input\_proxy\_vm\_settings) | Kasm Kasm Proxy-only node VM settings | <pre>object({<br>    shape                 = string<br>    disk_size_in_gbs      = number<br>    disk_vpus             = number<br>    memory_in_gbs         = number<br>    cpus                  = number<br>    utilization           = string<br>    recovery_action       = string<br>    maintenance_action    = string<br>    in_transit_encryption = bool<br>    enable_imdsv2         = bool<br>    live_migrate          = bool<br>    num_instances         = number<br>  })</pre> | n/a | yes |
| <a name="input_register_with_teleport"></a> [register\_with\_teleport](#input\_register\_with\_teleport) | Connect nodes deployed with this TF to auto register with Teleport | `bool` | `false` | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | SSH Public keys for bastion | <pre>object({<br>    management = string<br>    agent      = string<br>  })</pre> | <pre>{<br>  "agent": "",<br>  "management": ""<br>}</pre> | no |
| <a name="input_static_agent_nat_gateway"></a> [static\_agent\_nat\_gateway](#input\_static\_agent\_nat\_gateway) | Make Kasm agent subnets private and sit behind the NAT Gateway | `bool` | `false` | no |
| <a name="input_teleport_domain_name"></a> [teleport\_domain\_name](#input\_teleport\_domain\_name) | The teleport proxy domain name used to connect to the cluster | `string` | n/a | yes |
| <a name="input_teleport_identity_file"></a> [teleport\_identity\_file](#input\_teleport\_identity\_file) | The valid Teleport identity file use to authenticate Terraform | `string` | n/a | yes |
| <a name="input_teleport_join_token_lifetime_in_hrs"></a> [teleport\_join\_token\_lifetime\_in\_hrs](#input\_teleport\_join\_token\_lifetime\_in\_hrs) | The lifetime of the Teleport join token in hours | `number` | n/a | yes |
| <a name="input_teleport_roles"></a> [teleport\_roles](#input\_teleport\_roles) | A list of string of the teleport roles to assign to this token. Acceptable only value for this deployment stage is node. | `list(string)` | n/a | yes |
| <a name="input_teleport_version"></a> [teleport\_version](#input\_teleport\_version) | The teleport release version to install on the node | `string` | `"15.4.19"` | no |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | OCI Tenancy ID where you wish to install Kasm | `string` | n/a | yes |
| <a name="input_user_id"></a> [user\_id](#input\_user\_id) | OCI User ID with permission to create a compartment in Oracle Cloud | `string` | n/a | yes |
| <a name="input_vcn_name"></a> [vcn\_name](#input\_vcn\_name) | Display name for Kasm VCN | `string` | n/a | yes |
| <a name="input_vm_agent_key_name"></a> [vm\_agent\_key\_name](#input\_vm\_agent\_key\_name) | The Customer Managed KMS key name for the Agent/Windows VMs | `string` | `""` | no |
| <a name="input_vm_instance_lookups"></a> [vm\_instance\_lookups](#input\_vm\_instance\_lookups) | Filter values for VM image queries in OCI | <pre>map(object({<br>    os     = string<br>    filter = list(string)<br>  }))</pre> | <pre>{<br>  "kasm_oracle": {<br>    "filter": [<br>      "^Kasm-Oracle Linux 8 x86_64 - CIS Level 2 Hardened.*",<br>      "^Kasm-Oracle Linux 8 arm - CIS Level 2 Hardened.*"<br>    ],<br>    "os": "Oracle Linux"<br>  },<br>  "kasm_ubuntu": {<br>    "filter": [<br>      "^Kasm-Ubuntu 22.04 x86_64 - CIS Level 2 Hardened.*",<br>      "^Kasm-Ubuntu 22.04 arm - CIS Level 2 Hardened.*"<br>    ],<br>    "os": "Canonical Ubuntu"<br>  },<br>  "oracle": {<br>    "filter": [<br>      "^Oracle-Linux-8.8.*"<br>    ],<br>    "os": "Oracle Linux"<br>  },<br>  "ubuntu": {<br>    "filter": [<br>      "^Canonical-Ubuntu-22.04-Minimal-([\\.0-9-]+)$",<br>      "^Canonical-Ubuntu-22.04-Minimal-aarch64-([\\.0-9-]+)$"<br>    ],<br>    "os": "Canonical Ubuntu"<br>  },<br>  "windows": {<br>    "filter": [<br>      "^Windows-Server-2022-Standard-Edition-VM-*"<br>    ],<br>    "os": "Windows"<br>  }<br>}</pre> | no |
| <a name="input_vm_management_key_name"></a> [vm\_management\_key\_name](#input\_vm\_management\_key\_name) | The Customer Managed KMS key name for the Management VMs | `string` | `""` | no |
| <a name="input_wazuh_group"></a> [wazuh\_group](#input\_wazuh\_group) | The Wazuh group to join the instance to for administration | `string` | `""` | no |
| <a name="input_wazuh_token"></a> [wazuh\_token](#input\_wazuh\_token) | Wazuh agent password for agent auto-join | `string` | `""` | no |
| <a name="input_wazuh_url"></a> [wazuh\_url](#input\_wazuh\_url) | The Wazuh agent join URL | `string` | `""` | no |
| <a name="input_webapp_additional_install_arguments"></a> [webapp\_additional\_install\_arguments](#input\_webapp\_additional\_install\_arguments) | Additional arguments to send to the Kasm WebApp for advanced installations | `string` | `"-O"` | no |
| <a name="input_webapp_autoscale_config"></a> [webapp\_autoscale\_config](#input\_webapp\_autoscale\_config) | OCI Autoscale configuration for Kasm Connection Proxy (CPX) servers | <pre>map(object({<br>    config_name = string<br>    policy_type = string<br>    policy_name = string<br>    is_enabled  = bool<br>    min_size    = number<br>    max_size    = number<br>  }))</pre> | n/a | yes |
| <a name="input_webapp_vm_settings"></a> [webapp\_vm\_settings](#input\_webapp\_vm\_settings) | WebApp VM settings | <pre>object({<br>    shape                 = string<br>    disk_size_in_gbs      = number<br>    memory_in_gbs         = number<br>    disk_vpus             = number<br>    cpus                  = number<br>    utilization           = string<br>    recovery_action       = string<br>    maintenance_action    = string<br>    in_transit_encryption = bool<br>    enable_imdsv2         = bool<br>    live_migrate          = bool<br>    num_instances         = number<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscale_agent_config_override"></a> [autoscale\_agent\_config\_override](#output\_autoscale\_agent\_config\_override) | The Kasm Agent Autoscale config override settings to use |
| <a name="output_autoscale_agent_custom_tags"></a> [autoscale\_agent\_custom\_tags](#output\_autoscale\_agent\_custom\_tags) | Custom Tags to use for the Management Region Agent Autoscale group |
| <a name="output_autoscale_agent_startup_script_vars"></a> [autoscale\_agent\_startup\_script\_vars](#output\_autoscale\_agent\_startup\_script\_vars) | Kasm Agent autoscale script variables - lines 13-18 in the `autoscale_agent.sh` script |
| <a name="output_autoscale_agent_teleport_token"></a> [autoscale\_agent\_teleport\_token](#output\_autoscale\_agent\_teleport\_token) | Teleport token values to use for autoscaled agent startup configs |
| <a name="output_management_vm_autoscale_settings"></a> [management\_vm\_autoscale\_settings](#output\_management\_vm\_autoscale\_settings) | Settings used for deployment to copy/paste for Agent autoscaling |
| <a name="output_region1_agent_custom_tags"></a> [region1\_agent\_custom\_tags](#output\_region1\_agent\_custom\_tags) | Custom Tags to use for the Region 1 Agent Autoscale group |
| <a name="output_region1_vm_autoscale_settings"></a> [region1\_vm\_autoscale\_settings](#output\_region1\_vm\_autoscale\_settings) | Settings used for deployment to copy/paste for Agent autoscaling |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->