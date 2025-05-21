## ********************************* ##
##    07-compute BLUE tfvars file    ##
## ********************************* ##

/*
 * OCI Account connection variables
 */
tenancy_id           = ""
user_id              = ""
fingerprint          = ""
api_private_key_path = ""
oci_regions          = ["uk-london-1","us-ashburn-1"]
instance_principal   = ""

## OCI Compartment variables
compartment_name       = "Will-dev"
image_compartment_name = "Infra"
kasm_domain_name       = "kasm.willsmith.io"
parent_domain_name     = ""

## OCI VCN variables
vcn_name = "will-1161-vcn"

## Kasm deployment variables
project_name    = "will-ex"
customer_name   = "will-ex"
deployment_type = "Multi-Region"# Valid values: Multi-Region, Multi-Server, Single-Server
deployment      = "Blue"
kasm_version    = "1.16.1"

## Monitoring Configs
monitoring_domain = ""
wazuh_url         = ""
wazuh_group       = "will-ex"

## 1password settings
one_password_vault = "Engineering"
one_password_url   = "https://1password.willsmith.io"
one_password_tags  = ["will-ex"]

## Kasm build variables
image_type        = "ubuntu"
kasm_download_url = "https://kasm-static-content.s3.amazonaws.com/kasm_release_1.16.1.98d6fa.tar.gz"


## Agent NFS mount path if NFS persistent profiles used
deploy_nfs = false
# nfs_profile_path = "/kasm/profiles"

## Database public IP
database_ip = "Blue-database.private.kasm.willsmith.io"

## Teleport settings
register_with_teleport = true
teleport_domain_name   = "teleport.kasmweb.io"
teleport_roles         = ["node"]
teleport_identity_file = "../teleport-identity"
## If using Teleport, set the token lifetime to at least 6mos (4380 hrs) to compensate for
## webapp and agent autoscaling events that occur throughout the lifetime of a Kasm deployment
teleport_join_token_lifetime_in_hrs = 8766

## Customer Managed KMS Keys
customer_managed_keys  = false
vm_management_key_name = ""
vm_agent_key_name      = ""

## Kasm Webapp VM settings
webapp_additional_install_arguments = "-O"
webapp_vm_settings = {
  display_name          = "Kasm-Webapp"
  shape                 = "VM.Standard.E4.Flex"
  cpus                  = 8
  memory_in_gbs         = 8
  disk_size_in_gbs      = 80
  disk_vpus             = 120
  utilization           = "BASELINE_1_8" ## Burst utilization: BASELINE_1_1 is 100% : BASELINE_1_2 is 50% : BASELINE_1_8 is 12.5%
  recovery_action       = "RESTORE_INSTANCE"
  maintenance_action    = "LIVE_MIGRATE"
  in_transit_encryption = true
  enable_imdsv2         = true
  live_migrate          = true
  num_instances         = 2
}

webapp_autoscale_config = {
  webapp = {
    config_name = "kasm-webapp-autoscale"
    policy_name = "kasm-webapp-autoscale-policy"
    policy_type = "threshold"
    is_enabled  = true
    min_size    = 2
    max_size    = 6
  }
}

## Kasm Agent VM settings
agent_additional_install_arguments = "-O"
enable_gpu                         = false
number_of_kasm_agents              = 1
agent_vm_settings = {
  instance_state        = "RUNNING"
  shape                 = "VM.Standard.E4.Flex"
  disk_size_in_gbs      = 150
  disk_vpus             = 120
  memory_in_gbs         = 4
  cpus                  = 2
  in_transit_encryption = true
  utilization           = "BASELINE_1_1"
  enable_imdsv2         = true
}

## Kasm CPX (guacamole) VM settings
cpx_additional_install_arguments = "-O"
cpx_vm_settings = {
  display_name          = "Kasm-CPX"
  shape                 = "VM.Standard.E4.Flex"
  cpus                  = 2
  memory_in_gbs         = 6
  disk_size_in_gbs      = 80
  disk_vpus             = 120
  utilization           = "BASELINE_1_2" ## Burst utilization: BASELINE_1_1 is 100% : BASELINE_1_2 is 50% : BASELINE_1_8 is 12.5%
  recovery_action       = "RESTORE_INSTANCE"
  maintenance_action    = "LIVE_MIGRATE"
  in_transit_encryption = true
  enable_imdsv2         = true
  live_migrate          = true
  num_instances         = 1
}

cpx_autoscale_config = {
  cpx = {
    config_name = "kasm-cpx-autoscale"
    policy_name = "kasm-cpx-autoscale-policy"
    policy_type = "threshold"
    is_enabled  = true
    min_size    = 1
    max_size    = 3
  }
}

## Kasm Proxy-only VM settings
proxy_additional_install_arguments = "-O"
proxy_vm_settings = {
  display_name          = "Kasm-Proxy"
  shape                 = "VM.Standard.E4.Flex"
  cpus                  = 4
  memory_in_gbs         = 4
  disk_size_in_gbs      = 80
  disk_vpus             = 120
  utilization           = "BASELINE_1_8"
  recovery_action       = "RESTORE_INSTANCE"
  maintenance_action    = "LIVE_MIGRATE"
  in_transit_encryption = true
  enable_imdsv2         = true
  live_migrate          = true
  num_instances         = 2
}

proxy_autoscale_config = {
  proxy = {
    config_name = "kasm-proxy-autoscale"
    policy_name = "kasm-proxy-autoscale-policy"
    policy_type = "threshold"
    is_enabled  = true
    min_size    = 2
    max_size    = 5
  }
}

/*
 * ALL values below have default values set in variables.tf. Any you wish to change from the default
 * just uncomment and modify here, so you don't have to mess with the variables.tf file.
 */
## VMs SSH Keys
# ssh_public_keys = {
#   management = ""
#   agent      = ""
# }

## AWS region - this must be the "home region" to create DNS or AWS IAM users.
## For Kasm, us-east-1 is the AWS home region.
# aws_region = "us-east-1"

## Compartment variables
# is_child_compartment = true

## Default route/security list subnet
# anywhere = "0.0.0.0/0"

## VM Lookup regex values
# vm_instance_lookups = {
#   ubuntu = {
#     os     = "Canonical Ubuntu"
#     filter = ["^Canonical-Ubuntu-22.04-Minimal-([\\.0-9-]+)$", "^Canonical-Ubuntu-22.04-Minimal-aarch64-([\\.0-9-]+)$"]
#   }
#   oracle = {
#     os     = "Oracle Linux"
#     filter = ["^Oracle-Linux-8.8.*"]
#   }
#   kasm_ubuntu = {
#     os     = "Canonical Ubuntu"
#     filter = ["^Kasm \\d.(\\d){2}.*Management-Hardened-Ubuntu 20.04.*", "^Kasm \\d.(\\d){2}.*Agent-Hardened-Ubuntu 20.04.*"]
#   }
#   kasm_oracle = {
#     os     = "Oracle Linux"
#     filter = ["^Kasm.*([\\.0-9]+).*Management-Hardened-Oracle Linux 8.*", "^Kasm \\d.(\\d){2}.*Agent-Hardened-Ubuntu 20.04.*"]
#   }
# }

## OCI Region name to Kasm Zone name
# oci_region_to_kasm_zone_map = {
#   ap-sydney-1       = "Austrailia-(Sydney)"
#   ap-melbourne-1    = "Austrailia-(Melbourne)"
#   sa-saopaulo-1     = "Brazil-(Sao-Paulo)"
#   sa-vinhedo-1      = "Brazil-(Vinhedo)"
#   ca-montreal-1     = "Canada-(Montreal)"
#   ca-toronto-1      = "Canada-(Toronto)"
#   sa-santiago-1     = "Chile-(Santiago)"
#   eu-paris-1        = "France-(Paris)"
#   eu-marseille-1    = "France-(Marseille)"
#   eu-frankfurt-1    = "Germany-(Frankfurt)"
#   ap-hyderbad-1     = "India-(Hyderbad)"
#   ap-mumbai-1       = "India-(Mumbai)"
#   il-jerusalem-1    = "Israel-(Jerusalem)"
#   eu-milan-1        = "Italy-(Milan)"
#   ap-osaka-1        = "Japan-(Osaka)"
#   ap-tokyo-1        = "Japan-(Tokyo)"
#   mx-queretaro-1    = "Mexico-(Queretaro)"
#   mx-monterrey-1    = "Mexico-(Monterrey)"
#   eu-amsterdam-1    = "Netherlands-(Amsterdam)"
#   me-jeddah-1       = "Saudi-Arabia-(Jeddah)"
#   eu-jovanovac-1    = "Servia-(Jovanovac)"
#   ap-singapore-1    = "Asia-(Singapore)"
#   af-johannesburg-1 = "S-Africa-(Johannesburg)"
#   ap-seoul-1        = "S-Korea-(Seoul)"
#   ap-chuncheon-1    = "S-Korea-(Chuncheon)"
#   eu-madrid-1       = "Spani-(Madrid)"
#   eu-stockholm-1    = "Sweden-(Stockholm)"
#   eu-zurich-1       = "Switzerland-(Zurich)"
#   me-abudhabi-1     = "UAE-(Abu-Dhabi)"
#   me-dubai-1        = "UAE-(Dubai)"
#   uk-london-1       = "UK-(London)"
#   uk-cardiff-1      = "UK-(Cardiff)"
#   us-ashburn-1      = "USA-(Virginia)"
#   us-chicago-1      = "USA-(Illinois)"
#   us-phoenix-1      = "USA-(Arizona)"
#   us-sanjose-1      = "USA-(California)"
# }

## Variables used in resource labes, tags, or names
# deployment_strategy = ["blue", "green"]

# freeform_tags = {}
# defined_tags  = {}