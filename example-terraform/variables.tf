/*
 * OCI Provider authentication variables
 */
variable "tenancy_id" {
  description = "OCI Tenancy ID where you wish to install Kasm"
  type        = string

  validation {
    condition     = can(regex("^(ocid\\d)\\.(compartment|tenancy)\\.(oc\\d)[.]{1,}[a-z0-9]+", var.tenancy_id))
    error_message = "The variable tenancy_id must be a valid Oracle Cloud Tenancy OCID value."
  }
}

variable "instance_principal" {
  description = "Use OCI Instance Principal to authenticate instead of user-based API credentials"
  type        = string

  validation {
    condition     = contains(["", "InstancePrincipal"], var.instance_principal)
    error_message = "The variable tenancy_id must be a valid Oracle Cloud Tenancy OCID value."
  }
}

variable "oci_regions" {
  description = "OCI Region where you wish to install Kasm"
  type        = list(string)

  validation {
    condition     = alltrue([for region in var.oci_regions : can(regex("^([a-z]{2}-[a-z]{5,}-[\\d]{1})$", region))])
    error_message = "The region must be a valid Oracle Cloud (OCI) Region name, e.g. us-ashburn-1"
  }
}

variable "user_id" {
  description = "OCI User ID with permission to create a compartment in Oracle Cloud"
  type        = string

  validation {
    condition     = var.user_id == "" || can(regex("^(ocid\\d)\\.user\\.(oc\\d)[.]{1,}[a-z0-9]+", var.user_id))
    error_message = "The variable user_id is a boolean value and must be either: true or false."
  }
}

variable "fingerprint" {
  description = "OCI User Private API key fingerprint value"
  type        = string

  validation {
    condition     = var.fingerprint == "" || can(regex("^([a-f0-9]{2}:?){16}", var.fingerprint))
    error_message = "The variable fingerprint should be a 2 digit colon (:) separated hex string with 16 blocks (e.g. 12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef)."
  }
}

variable "api_private_key_path" {
  description = "OCI User API private key file"
  type        = string

  validation {
    condition     = var.api_private_key_path == "" || fileexists(var.api_private_key_path)
    error_message = "The variable api_private_key_path must point to a valid OCI API Key file."
  }
  validation {
    condition     = var.api_private_key_path == "" || can(regex("^[-]{5}BEGIN (RSA )?PRIVATE KEY[-]{5}", file(var.api_private_key_path)))
    error_message = "The contents of the file at the api_private_key_path destination are not in the correct RSA Private Key format."
  }
}

/*
 * AWS Provider authentication variables
 * To use the aws_access_key and aws_secret_key variables, rename the secrets.tfvars.example file to secrets.tfvars, uncomment
 * the necessary variables, and configure them with the appropriate values. There's already an entry in the .gitignore to prevent
 * secrets.tfvars from syncing, so there's no worry secret values will get pushed to source control.
 */
variable "aws_access_key" {
  description = "AWS Access Key ID value used in lieu of environment variable-based AWS authentication"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS Secret Key value used in lieu of environment variable-based AWS authentication"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS Region where you wish to create the Kasm DNS zone"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]{4,}-[\\d]{1})$", var.aws_region))
    error_message = "The aws_region must be a valid Amazon Web Services (AWS) Region name, e.g. us-east-1"
  }
}

/*
 * OCI Compartment Info
 */
variable "compartment_name" {
  description = "The name of the new Kasm compartment"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-_]{1,100}?", var.compartment_name))
    error_message = "The compartment_name variable can only consist of a maximum of 100 characters, including letters, numbers, periods, hyphens, and underscores, and the name must be unique across all the compartments in your tenancy."
  }
}

variable "image_compartment_name" {
  description = "The name of the new Kasm compartment"
  type        = string
  default     = "customer_deployments"

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-_]{1,100}?", var.image_compartment_name))
    error_message = "The image_compartment_name variable can only consist of a maximum of 100 characters, including letters, numbers, periods, hyphens, and underscores, and the name must be unique across all the compartments in your tenancy."
  }
}

variable "kasm_domain_name" {
  description = "The domain name to use for your Kasm deployment - used when creating a new DNS zone"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,6}", var.kasm_domain_name))
    error_message = "There are invalid characters in the kasm_domain_name - it must be a valid domain name."
  }
}

variable "parent_domain_name" {
  description = "The Parent (or root) domain name to use for your Kasm deployment - used when adding DNS zone NS records to the Parent zone"
  type        = string
  default     = ""

  validation {
    condition     = var.parent_domain_name == "" || can(regex("^[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,6}", var.parent_domain_name))
    error_message = "There are invalid characters in the parent_domain_name - it must be a valid domain name."
  }
}

/*
 * Monitoring Configs
 */

variable "monitoring_domain" {
  description = "Deployment domain name to register with Monitoring agent"
  type        = string
  default     = ""
}

variable "enable_grafana" {
  description = "Enable log forwarding to Grafana"
  type        = bool
  default     = true
}
variable "grafana_username" {
  description = "The API User Credential to forward Kasm logs to Grafana"
  type        = string
  default     = ""
}
variable "grafana_password" {
  description = "The API Password Credential to forward Kasm logs to Grafana"
  type        = string
  default     = ""
}

variable "wazuh_token" {
  description = "Wazuh agent password for agent auto-join"
  type        = string
  default     = ""
}

variable "wazuh_group" {
  description = "The Wazuh group to join the instance to for administration"
  type        = string
  default     = ""
}

variable "wazuh_url" {
  description = "The Wazuh agent join URL"
  type        = string
  default     = ""
}

/*
 * OCI VCN and region-specific Info
 */

variable "vcn_name" {
  description = "Display name for Kasm VCN"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-_]{1,100}?", var.vcn_name))
    error_message = "The vcn_name variable can only consist of a maximum of 100 characters, including letters, numbers, periods (.), dashes (-), and underscores (_)."
  }
}

variable "image_type" {
  description = "The image type to use, whether the default maintainer version, or the kasm pre-built image."
  type        = string

  validation {
    condition     = contains(["ubuntu", "kasm_ubuntu", "oracle", "kasm_oracle"], var.image_type)
    error_message = "The image_type variable can only be ubuntu (for the Cannonical default Ubuntu 22.04 image), kasm_ubuntu (for the Ubuntu-based Kasm pre-built image), oracle (for the Oracle Linux default 8.x image), or kasm_oracle (for the Oracle Linux-based Kasm pre-built image)."
  }
}

/*
 * Kasm deployment information used for freeform tags, resource labels or prefixes, and downloads
 */
variable "project_name" {
  description = "Value to use for VCN prefix to make it unique. Usually a customer name (or customer short name)."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-_]{1,15}", var.project_name))
    error_message = "The project_name can only be between 1 and 15 characters consisting of letters, numbers, dashes (-), and underscores (_)."
  }
}

variable "customer_name" {
  description = "The full name of the new Kasm Customer"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-_ ]{1,256}?", var.customer_name))
    error_message = "The project_name variable can only consist of a maximum of 20 characters including letters, numbers, dash (-), underscore (_), period (.), and space ( )."
  }
}

variable "deployment" {
  description = "The type of deployment to build. Acceptable values are blue or green."
  type        = string

  validation {
    condition     = contains(["blue", "green"], lower(var.deployment))
    error_message = "The deployment is a string that can only be blue, or green. Other deployment strategies may be supported in the future."
  }
}

variable "kasm_version" {
  description = "Kasm version to deploy"
  type        = string

  validation {
    condition     = can(regex("[\\d{1}\\.\\d{2}\\.\\d{1}|develop]", var.kasm_version))
    error_message = "The kasm_version can only consist of Kasm release versions. Acceptable value format is #.##.#, or develop."
  }
}

variable "kasm_download_url" {
  description = "The URL for the Kasm Workspaces build"
  type        = string
}

variable "deployment_type" {
  description = "Type of Kasm deployment"
  type        = string

  validation {
    condition     = can(regex("(?i:multi-region|multi-server|single-server)", var.deployment_type))
    error_message = "The deployment_type variable can only be one of Multi-Region, Multi-Server, or Single-Server."
  }
}

variable "deployment_strategy" {
  description = "The type of deployment to build. Acceptable values are blue-green, or rolling."
  type        = list(string)
  default     = ["Blue", "Green"]

  validation {
    condition     = alltrue([for strategy in var.deployment_strategy : contains(["Blue", "Green"], strategy)])
    error_message = "The deployment_strategy is a string that can only be [Blue, Green]. Support for Rolling or other deployment strategies may be developed later."
  }
}

/*
 * Teleport proxy domain name
 */
variable "register_with_teleport" {
  description = "Connect nodes deployed with this TF to auto register with Teleport"
  type        = bool
  default     = false
}

variable "teleport_domain_name" {
  description = "The teleport proxy domain name used to connect to the cluster"
  type        = string
}

variable "teleport_version" {
  description = "The teleport release version to install on the node"
  type        = string
  default     = "15.4.19"
}

variable "teleport_roles" {
  description = "A list of string of the teleport roles to assign to this token. Acceptable only value for this deployment stage is node."
  type        = list(string)

  validation {
    condition     = length(var.teleport_roles) == 0 || alltrue([for role in var.teleport_roles : can(regex("(?i:node)", role))])
    error_message = "The only acceptable teleport_role is node."
  }
}

variable "teleport_join_token_lifetime_in_hrs" {
  description = "The lifetime of the Teleport join token in hours"
  type        = number

  validation {
    condition     = var.teleport_join_token_lifetime_in_hrs == 0 || var.teleport_join_token_lifetime_in_hrs >= 1
    error_message = "The teleport_join_token_lifetime_in_hrs must be a valid number greater than or equal to 1 - IF - register_with_teleport is true."
  }
}

variable "teleport_identity_file" {
  description = "The valid Teleport identity file use to authenticate Terraform"
  type        = string

  validation {
    condition     = var.teleport_identity_file == "" || fileexists(var.teleport_identity_file)
    error_message = "The file name provided for the teleport_identity_file does not exist at that path."
  }
}
/*
 * Additional Kasm services or service configurations
 */
variable "oci_region_to_kasm_zone_map" {
  description = "OCI Region mapped to associated Kasm zone name"
  type        = map(string)
  default = {
    ap-sydney-1       = "Australia-(Sydney)"
    ap-melbourne-1    = "Australia-(Melbourne)"
    sa-saopaulo-1     = "Brazil-(Sao-Paulo)"
    sa-vinhedo-1      = "Brazil-(Vinhedo)"
    ca-montreal-1     = "Canada-(Montreal)"
    ca-toronto-1      = "Canada-(Toronto)"
    sa-santiago-1     = "Chile-(Santiago)"
    eu-paris-1        = "France-(Paris)"
    eu-marseille-1    = "France-(Marseille)"
    eu-frankfurt-1    = "Germany-(Frankfurt)"
    ap-hyderbad-1     = "India-(Hyderbad)"
    ap-mumbai-1       = "India-(Mumbai)"
    il-jerusalem-1    = "Israel-(Jerusalem)"
    eu-milan-1        = "Italy-(Milan)"
    ap-osaka-1        = "Japan-(Osaka)"
    ap-tokyo-1        = "Japan-(Tokyo)"
    mx-queretaro-1    = "Mexico-(Queretaro)"
    mx-monterrey-1    = "Mexico-(Monterrey)"
    eu-amsterdam-1    = "Netherlands-(Amsterdam)"
    me-jeddah-1       = "Saudi-Arabia-(Jeddah)"
    eu-jovanovac-1    = "Servia-(Jovanovac)"
    ap-singapore-1    = "Asia-(Singapore)"
    af-johannesburg-1 = "S-Africa-(Johannesburg)"
    ap-seoul-1        = "S-Korea-(Seoul)"
    ap-chuncheon-1    = "S-Korea-(Chuncheon)"
    eu-madrid-1       = "Spani-(Madrid)"
    eu-stockholm-1    = "Sweden-(Stockholm)"
    eu-zurich-1       = "Switzerland-(Zurich)"
    me-abudhabi-1     = "UAE-(Abu-Dhabi)"
    me-dubai-1        = "UAE-(Dubai)"
    uk-london-1       = "UK-(London)"
    uk-cardiff-1      = "UK-(Cardiff)"
    us-ashburn-1      = "USA-(Virginia)"
    us-chicago-1      = "USA-(Illinois)"
    us-phoenix-1      = "USA-(Arizona)"
    us-sanjose-1      = "USA-(California)"
  }
}

variable "static_agent_nat_gateway" {
  description = "Make Kasm agent subnets private and sit behind the NAT Gateway"
  type        = bool
  default     = false
}


variable "enable_sysbox" {
  description = "Enable Sysbox on Agents for Sudo privileges."
  type        = bool
  default     = false
}

variable "deploy_nfs" {
  description = "true makes Kasm agents sit behind the NAT Gateway"
  type        = bool
  default     = false
}

variable "ssh_public_keys" {
  description = "SSH Public keys for bastion"
  type = object({
    management = string
    agent      = string
  })
  default = {
    agent      = ""
    management = ""
  }

  validation {
    condition     = alltrue([for key, value in var.ssh_public_keys : can(regex("^(ssh-rsa|ssh-ed25519)", value)) || value == ""])
    error_message = "The ssh_public_keys can only be a valid RSA or ED-25519 SSH Public key."
  }
}

/*
 * Kasm VM settings
 */
variable "customer_managed_keys" {
  description = "Use Customer Managed KMS keys to encrypt Object buckets"
  type        = bool
  default     = false
}

variable "vm_management_key_name" {
  description = "The Customer Managed KMS key name for the Management VMs"
  type        = string
  default     = ""
}

variable "vm_agent_key_name" {
  description = "The Customer Managed KMS key name for the Agent/Windows VMs"
  type        = string
  default     = ""
}

variable "database_ip" {
  description = "Kasm Database IP address or hostname"
  type        = string
}

## Webapp settings
variable "webapp_vm_settings" {
  description = "WebApp VM settings"
  type = object({
    shape                 = string
    disk_size_in_gbs      = number
    memory_in_gbs         = number
    disk_vpus             = number
    cpus                  = number
    utilization           = string
    recovery_action       = string
    maintenance_action    = string
    in_transit_encryption = bool
    enable_imdsv2         = bool
    live_migrate          = bool
    num_instances         = number
  })
}

variable "webapp_autoscale_config" {
  description = "OCI Autoscale configuration for Kasm Connection Proxy (CPX) servers"
  type = map(object({
    config_name = string
    policy_type = string
    policy_name = string
    is_enabled  = bool
    min_size    = number
    max_size    = number
  }))
}

variable "webapp_additional_install_arguments" {
  description = "Additional arguments to send to the Kasm WebApp for advanced installations"
  type        = string
  default     = "-O"

  validation {
    condition     = var.webapp_additional_install_arguments == "" || can(regex("^[\\d\\w]*", var.webapp_additional_install_arguments))
    error_message = "The webapp_additional_install_arguments variable can only be valid Kasm arguments. Refer to the Kasm install documentation for additional details."
  }
}

## Agent settings
variable "agent_vm_settings" {
  description = "Agent VM settings"
  type = object({
    instance_state        = string
    shape                 = string
    disk_size_in_gbs      = number
    disk_vpus             = number
    memory_in_gbs         = number
    cpus                  = number
    in_transit_encryption = bool
    utilization           = string
    enable_imdsv2         = bool
    backup_policy         = optional(string)
  })
}

variable "agent_additional_install_arguments" {
  description = "Additional arguments to send to the Kasm agent for advanced installations"
  type        = string
  default     = "-O"

  validation {
    condition     = var.agent_additional_install_arguments == "" || can(regex("^[\\d\\w]*", var.agent_additional_install_arguments))
    error_message = "The agent_additional_install_arguments variable can only be valid Kasm arguments. Refer to the Kasm install documentation for additional details."
  }
}

variable "number_of_kasm_agents" {
  description = "The number of static Kasm agents to deploy"
  type        = number

  validation {
    condition     = var.number_of_kasm_agents == null || can(regex("^[\\d]", var.number_of_kasm_agents))
    error_message = "The number_of_kasm_agents variable should be a number greater than 0. If you are deploying webapps as an autoscale group, then set this value to 0, or comment it out from the terraform.tfvars file to accept the default null value."
  }
}

variable "enable_gpu" {
  description = "Whether or not to install GPU libraries on the Kasm Agent"
  type        = bool
  default     = false

  validation {
    condition     = contains([true, false], var.enable_gpu)
    error_message = "The variable enable_gpu is a boolean value and must be either: true or false."
  }
}

variable "nfs_profile_path" {
  description = "The NFS export mount path for persistent profiles"
  type        = string
  default     = "/kasm/profiles"
}

## CPX settings
variable "cpx_vm_settings" {
  description = "Kasm Connection Proxy (CPX) VM settings"
  type = object({
    shape                 = string
    disk_size_in_gbs      = number
    memory_in_gbs         = number
    disk_vpus             = number
    cpus                  = number
    utilization           = string
    recovery_action       = string
    maintenance_action    = string
    in_transit_encryption = bool
    enable_imdsv2         = bool
    live_migrate          = bool
    num_instances         = number
  })
}

variable "cpx_autoscale_config" {
  description = "OCI Autoscale configuration for Kasm Connection Proxy (CPX) servers"
  type = map(object({
    config_name = string
    policy_type = string
    policy_name = string
    is_enabled  = bool
    min_size    = number
    max_size    = number
  }))
}

variable "cpx_additional_install_arguments" {
  description = "Additional arguments to send to the Kasm Connection Proxy (CPX) for advanced installations"
  type        = string
  default     = "-O"

  validation {
    condition     = var.cpx_additional_install_arguments == "" || can(regex("^[\\d\\w]*", var.cpx_additional_install_arguments))
    error_message = "The cpx_additional_install_arguments variable can only be valid Kasm arguments. Refer to the Kasm install documentation for additional details."
  }
}

## Proxy settings
variable "proxy_vm_settings" {
  description = "Kasm Kasm Proxy-only node VM settings"
  type = object({
    shape                 = string
    disk_size_in_gbs      = number
    disk_vpus             = number
    memory_in_gbs         = number
    cpus                  = number
    utilization           = string
    recovery_action       = string
    maintenance_action    = string
    in_transit_encryption = bool
    enable_imdsv2         = bool
    live_migrate          = bool
    num_instances         = number
  })
}

variable "proxy_autoscale_config" {
  description = "OCI Autoscale configuration for Kasm Proxy-only nodes servers"
  type = map(object({
    config_name = string
    policy_type = string
    policy_name = string
    is_enabled  = bool
    min_size    = number
    max_size    = number
  }))
}

variable "proxy_additional_install_arguments" {
  description = "Additional arguments to send to the Kasm Proxy-only nodes for advanced installations"
  type        = string
  default     = "-O"

  validation {
    condition     = var.proxy_additional_install_arguments == "" || can(regex("^[\\d\\w]*", var.proxy_additional_install_arguments))
    error_message = "The proxy_additional_install_arguments variable can only be valid Kasm arguments. Refer to the Kasm install documentation for additional details."
  }
}

variable "kasm_database_password" {
  description = "The password for the database. No special characters"
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = var.kasm_database_password == "" || can(regex("^[a-zA-Z0-9]{12,40}", var.kasm_database_password))
    error_message = "The Kasm Database should be a string between 12 and 40 letters or numbers with no special characters."
  }
}

variable "kasm_redis_password" {
  description = "The password for the Redis server. No special characters"
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = var.kasm_redis_password == "" || can(regex("^[a-zA-Z0-9]{12,40}", var.kasm_redis_password))
    error_message = "The Kasm Redis should be a string between 12 and 40 letters or numbers with no special characters."
  }
}

variable "kasm_manager_token" {
  description = "The manager token value for Agents to authenticate to webapps. No special characters"
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = var.kasm_manager_token == "" || can(regex("^[a-zA-Z0-9-]{12,40}", var.kasm_manager_token))
    error_message = "The Manager Token should be a string between 12 and 40 letters or numbers with no special characters."
  }
}

variable "kasm_service_token" {
  description = "The service registration token value for Guac RDP servers to authenticate to webapps. No special characters"
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = var.kasm_service_token == "" || can(regex("^[a-zA-Z0-9-]{12,40}", var.kasm_service_token))
    error_message = "The Service Registration Token should be a string between 12 and 40 letters or numbers with no special characters."
  }
}

## Pre-set settings
variable "vm_instance_lookups" {
  description = "Filter values for VM image queries in OCI"
  type = map(object({
    os     = string
    filter = list(string)
  }))

  default = {
    ubuntu = {
      os     = "Canonical Ubuntu"
      filter = ["^Canonical-Ubuntu-22.04-Minimal-([\\.0-9-]+)$", "^Canonical-Ubuntu-22.04-Minimal-aarch64-([\\.0-9-]+)$"]
    }
    oracle = {
      os     = "Oracle Linux"
      filter = ["^Oracle-Linux-8.8.*"]
    }
    kasm_ubuntu = {
      os     = "Canonical Ubuntu"
      filter = ["^Kasm-Ubuntu 22.04 x86_64 - CIS Level 2 Hardened.*", "^Kasm-Ubuntu 22.04 arm - CIS Level 2 Hardened.*"]
    }
    kasm_oracle = {
      os     = "Oracle Linux"
      filter = ["^Kasm-Oracle Linux 8 x86_64 - CIS Level 2 Hardened.*", "^Kasm-Oracle Linux 8 arm - CIS Level 2 Hardened.*"]
    }
    windows = {
      os     = "Windows"
      filter = ["^Windows-Server-2022-Standard-Edition-VM-*"]
    }
  }
}

variable "is_child_compartment" {
  description = "Is the compartment used for this deployment a child of any other compartments (including the tenancy)?"
  type        = bool
  default     = true
}

variable "nginx_cert" {
  description = "Nginx certificate to upload to Agent"
  type        = string
  default     = ""
}

variable "nginx_key" {
  description = "Nginx private key to upload to Agent"
  type        = string
  default     = ""
}

variable "freeform_tags" {
  description = "Default tags to add to Terraform-deployed Kasm services"
  type        = map(any)
  default     = null
}

variable "defined_tags" {
  description = "Default Defined tags to add to the Terraform-deployed resources"
  type        = map(any)
  default     = null
}

variable "one_password_vault" {
  description = "The 1Password vault to inject/retrieve secrets from"
  type        = string
  default     = "Customer-Deployments"

  validation {
    condition     = contains(["Customer-Deployments", "Kasm Commercial SaaS", "Engineering"], var.one_password_vault)
    error_message = "The one_password_vault variable can only be one of 'Customer-Deployments', 'Kasm Commercial SaaS', or 'Engineering'."
  }
}

variable "one_password_url" {
  description = "URL of the 1Password Connect server"
  type        = string
  default     = "https://1password.willsmith.io"

}

variable "one_password_token" {
  description = "Authentication token for 1Password Connect Server"
  type        = string

}

variable "one_password_tags" {
  description = "Organization Tags associated with 1Pass secret"
  type        = list(string)
  default     = []
}

