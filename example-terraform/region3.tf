# /*
#  * region 3 region resources
#  */
# ## Kasm agent
# module "region3_kasm_agents" {
#   source   = "./modules/instance"
#   for_each = local.region3_agent_vm_settings

#   compartment_id   = local.compartment_id
#   image_id         = local.region3_image_ids["agent"]
#   subnet_id        = local.region3_subnets["agent"].subnet_id
#   ssh_public_key   = local.agent_ssh_public_key
#   vm_settings      = { (each.key) = each.value }
#   nsg_ids          = local.region3_nsgs["agent"]
#   user_data        = local.region3_agent_user_data
#   assign_public_ip = local.agent_public_ip
#   kms_key_id       = var.customer_managed_keys ? local.region3_kms_key_ids[(var.vm_agent_key_name)] : ""
#   oci_region       = var.oci_regions[3]
#   freeform_tags    = local.freeform_tags
#   defined_tags     = local.defined_tags

#   providers = {
#     oci = oci.region3
#   }
# }

# ## Kasm proxy
# module "region3_kasm_proxy" {
#   source   = "./modules/autoscale_instance"
#   for_each = local.region3_proxy_vm_settings

#   compartment_id               = local.compartment_id
#   ssh_public_key               = local.management_ssh_public_key
#   image_id                     = local.region3_image_ids["proxy"]
#   nsg_ids                      = local.region3_nsgs["proxy"]
#   label_prefix                 = "${var.deployment}-${var.oci_regions[3]}"
#   subnet_id                    = local.region3_subnets["proxy"].subnet_id
#   vm_settings                  = local.region3_proxy_vm_settings
#   autoscale_config             = var.proxy_autoscale_config
#   user_data                    = local.region3_proxy_user_data
#   instance_pool_name           = "Proxy-instance-pool"
#   kms_key_id                   = var.customer_managed_keys ? local.region3_kms_key_ids[(var.vm_management_key_name)] : ""
#   load_balacner_and_backendset = local.region3_load_balancer_and_backend_sets
#   freeform_tags                = local.freeform_tags
#   defined_tags                 = local.defined_tags

#   providers = {
#     oci = oci.region3
#   }
# }

# ## Kasm Connection proxy (CPX)
# module "region3_kasm_cpx" {
#   source   = "./modules/autoscale_instance"
#   for_each = local.region3_cpx_vm_settings

#   compartment_id     = local.compartment_id
#   ssh_public_key     = local.management_ssh_public_key
#   image_id           = local.region3_image_ids["cpx"]
#   label_prefix       = "${var.deployment}-${var.oci_regions[3]}"
#   nsg_ids            = local.region3_nsgs["cpx"]
#   subnet_id          = local.region3_subnets["cpx"].subnet_id
#   vm_settings        = local.region3_cpx_vm_settings
#   autoscale_config   = var.cpx_autoscale_config
#   user_data          = local.region3_cpx_user_data
#   instance_pool_name = "CPX-instance-pool"
#   kms_key_id         = var.customer_managed_keys ? local.region3_kms_key_ids[(var.vm_management_key_name)] : ""
#   freeform_tags      = local.freeform_tags
#   defined_tags       = local.defined_tags

#   providers = {
#     oci = oci.region3
#   }
# }

# module "region3_op_upload" {
#   source   = "./modules/1Password"
#   for_each = local.region3_op_secrets_contents

#   vault          = var.one_password_vault
#   section_values = each.value.section_values
#   tags           = var.one_password_tags
#   secret_name    = each.key
#   secret_url     = var.kasm_domain_name
# }


# /*
#  * region3 region provider
#  */
# provider "oci" {
#   alias               = "region3"
#   tenancy_ocid        = var.tenancy_id
#   user_ocid           = var.instance_principal == "" ? var.user_id : null
#   fingerprint         = var.instance_principal == "" ? var.fingerprint : null
#   private_key_path    = var.instance_principal == "" ? var.api_private_key_path : null
#   region              = var.oci_regions[3]
#   auth                = var.instance_principal != "" ? var.instance_principal : null
#   ignore_defined_tags = ["Oracle-Tags.CreatedBy", "Oracle-Tags.CreatedOn"]
# }


# /*
#  * region3 data resource lookups
#  */
# data "oci_core_vcns" "region3_vcn" {
#   compartment_id = local.compartment_id
#   display_name   = var.vcn_name
#   provider       = oci.region3
# }

# data "oci_core_subnets" "region3_subnets" {
#   compartment_id = local.compartment_id
#   vcn_id         = data.oci_core_vcns.region3_vcn.virtual_networks[0].id
#   provider       = oci.region3
# }

# data "oci_identity_availability_domains" "region3_ads" {
#   compartment_id = local.compartment_id
#   provider       = oci.region3
# }

# data "oci_core_network_security_groups" "region3_network_security_groups" {
#   compartment_id = local.compartment_id
#   vcn_id         = data.oci_core_vcns.region3_vcn.virtual_networks[0].id
#   provider       = oci.region3
# }

# data "oci_core_images" "region3_image" {
#   for_each = local.region3_image_shapes

#   compartment_id   = local.image_compartment_id
#   shape            = each.value.shape
#   operating_system = var.vm_instance_lookups[each.value.image_type].os
#   filter {
#     name   = "display_name"
#     values = [can(regex("A1", each.value)) ? var.vm_instance_lookups[each.value.image_type].filter[1] : var.vm_instance_lookups[each.value.image_type].filter[0]]
#     regex  = true
#   }
#   provider = oci.region3
# }

# data "oci_load_balancers" "region3_lbs" {
#   compartment_id = local.compartment_id
#   provider       = oci.region3
# }

# data "oci_load_balancer_backend_sets" "region3_backend_sets" {
#   for_each = { for lb in data.oci_load_balancers.region3_lbs.load_balancers : lb.display_name => lb }

#   load_balancer_id = each.value.id
#   provider         = oci.region3
# }

# data "oci_kms_vaults" "region3_vault" {
#   count          = var.customer_managed_keys ? 1 : 0
#   compartment_id = local.compartment_id
#   provider       = oci.region3
# }

# data "oci_kms_keys" "region3_keys" {
#   count               = var.customer_managed_keys ? 1 : 0
#   compartment_id      = local.compartment_id
#   management_endpoint = data.oci_kms_vaults.region3_vault[(count.index)].vaults[(count.index)].management_endpoint
#   provider            = oci.region3
# }

# /*
#  * region3 region locals
#  */
# locals {
#   ## region3 subnet to subnet_id and cidr_block map
#   region3_subnets = {
#     for index, subnet in data.oci_core_subnets.region3_subnets.subnets : (can(regex("(?i:proxy)", subnet.display_name)) ? "proxy" : can(regex("(?i:cpx)", subnet.display_name)) ? "cpx" : can(regex("(?i:agent-private)", subnet.display_name)) ? "agent-private" : can(regex("(?i:agent-public)", subnet.display_name)) ? "agent-public" : can(regex("(?i:windows-public)", subnet.display_name)) ? "windows-public" : can(regex("(?i:windows-private)", subnet.display_name)) ? "windows-private" : subnet.display_name) => {
#       cidr_block = subnet.cidr_block
#       subnet_id  = subnet.id
#     } if can(regex("(?i:proxy)", subnet.display_name)) || can(regex("(?i:cpx)", subnet.display_name)) || can(regex("(?i:agent)", subnet.display_name)) || can(regex("(?i:windows)", subnet.display_name))
#   }

#   ## region3 network security group name to id map
#   region3_nsgs = {
#     for index, nsg in data.oci_core_network_security_groups.region3_network_security_groups.network_security_groups : can(regex("(?i:proxy)", nsg.display_name)) ? "proxy" : can(regex("(?i:agent)", nsg.display_name)) ? "agent" : can(regex("(?i:cpx)", nsg.display_name)) ? "cpx" : can(regex("(?i:windows)", nsg.display_name)) ? "windows" : nsg.display_name => [nsg.id] if can(regex("(?i:proxy)", nsg.display_name)) || can(regex("(?i:agent)", nsg.display_name)) || can(regex("(?i:cpx)", nsg.display_name)) || can(regex("(?i:windows)", nsg.display_name))
#   }

#   ## Map of OS image shapes to get image ids for instances
#   region3_image_shapes = {
#     webapp = {
#       shape      = var.webapp_vm_settings.shape,
#       image_type = var.image_type
#     }
#     agent = {
#       shape      = var.agent_vm_settings.shape,
#       image_type = var.image_type
#     }
#     cpx = {
#       shape      = var.cpx_vm_settings.shape,
#       image_type = var.image_type
#     }
#     proxy = {
#       shape      = var.proxy_vm_settings.shape,
#       image_type = var.image_type
#     }
#     windows = {
#       shape      = "VM.Standard.E4.Flex",
#       image_type = "windows"
#     }
#   }

#   ## Management KMS Keys
#   region3_kms_key_ids = var.customer_managed_keys ? { for key, value in data.oci_kms_keys.region3_keys[0].keys : value.display_name => value.id if can(regex("(?i:${var.vm_management_key_name}|${var.vm_agent_key_name})", value.display_name)) } : {}

#   ## Map of OS image IDs depending on OS deployment type. Valid values are ubuntu, oracle, kasm_ubuntu, kasm_oracle
#   region3_image_ids = merge([{
#     proxy = data.oci_core_images.region3_image["proxy"].images[0].id
#     agent = data.oci_core_images.region3_image["agent"].images[0].id
#     }, {
#     cpx     = data.oci_core_images.region3_image["cpx"].images[0].id
#     windows = data.oci_core_images.region3_image["windows"].images[0].id
#     }
#   ]...)

#   ## region3 VM Configuration settings
#   region3_proxy_vm_settings =  { "Proxy-config" = var.proxy_vm_settings }
#   region3_cpx_vm_settings   = { "CPX-config" = var.cpx_vm_settings }
#   region3_agent_vm_settings = { for agent in range(var.number_of_kasm_agents) : "${title(var.deployment)}-Static-Agent-${agent}" => var.agent_vm_settings }

#   ## Load Balancer settings for WebApp Pool configuration
#   region3_load_balancer_and_backend_sets =  {
#     public = {
#       load_balancer_id = [for lb in data.oci_load_balancers.region3_lbs.load_balancers : lb.id if can(regex("(?i:${var.oci_regions[3]}.${var.deployment}.public.load.balancer)", lb.display_name))][0]
#       backendset_name  = [for key, value in data.oci_load_balancer_backend_sets.region3_backend_sets : value.backendsets[0].name if can(regex("(?i:${var.oci_regions[3]}.${var.deployment}.public.load.balancer)", key))][0]
#       port             = 443
#       vnic             = "PrimaryVnic"
#     }
#   }

#   # region3_autoscale_user_data = templatefile("../userdata/autoscale_agent.sh", {
#   #   IMAGE_TYPE                     = var.image_type
#   #   KASM_DOMAIN_NAME               = var.kasm_domain_name
#   #   KASM_MANAGER_TOKEN             = var.kasm_manager_token
#   #   DEPLOYMENT_TYPE                = var.deployment_type
#     KASM_VERSION                = var.kasm_version
#   #   DB_PRIVATE_IP                  = var.database_ip
#   #   REDIS_PRIVATE_IP               = var.database_ip
#   #   KASM_DB_PASS                   = var.kasm_database_password
#   #   KASM_REDIS_PASS                = var.kasm_redis_password
#   #   KASM_DOWNLOAD_URL              = var.kasm_download_url
#   #   ADDITIONAL_WEBAPP_INSTALL_ARGS = var.webapp_additional_install_arguments
#   #   KASM_ZONE_NAME                 = var.oci_region_to_kasm_zone_map[region]
#   #   TELEPORT_TOKEN                 = local.teleport_join_token
#   #   TELEPORT_CA                    = local.teleport_ca_pin
#   #   TELEPORT_DOMAIN_NAME           = local.teleport_domain_name
#   #   NODE_NAME                      = "${upper(var.project_name)}-${title(var.deployment)}-Webapp"
#   #   PROJECT_NAME                   = var.project_name
#   #   WAZUH_TOKEN                    = var.wazuh_token
#   #   WAZUH_URL                      = var.wazuh_url
#   #   WAZUH_GROUP                    = var.wazuh_group
#   # })

#   region3_windows_user_data = file("../userdata/windows_userdata.ps1")
#   ## Proxy User Data configuration
#   region3_proxy_lb_url  = "${split("-", var.oci_regions[3])[1]}-proxy.${var.kasm_domain_name}"
#   region3_public_lb_url = var.kasm_domain_name #"${split("-", var.oci_regions[3])[1]}-lb.${var.kasm_domain_name}"
#   region3_proxy_user_data = base64encode(templatefile("../userdata/proxy_userdata.sh", {
#     IMAGE_TYPE                    = var.image_type
#     KASM_DOMAIN_NAME              = var.kasm_domain_name
#     DEPLOYMENT_TYPE               = var.deployment_type
#     KASM_VERSION                = var.kasm_version
#     KASM_DOWNLOAD_URL             = var.kasm_download_url
#     KASM_DOMAIN_NAME              = var.kasm_domain_name
#     ADDITIONAL_PROXY_INSTALL_ARGS = var.proxy_additional_install_arguments
#     REGION_PROXY_DOMAIN_NAME      = local.region3_proxy_lb_url
#     REGION_LB_DOMAIN_NAME         = local.region3_public_lb_url
#     TELEPORT_TOKEN                = local.teleport_join_token
#     TELEPORT_CA                   = local.teleport_ca_pin
#     TELEPORT_DOMAIN_NAME          = local.teleport_domain_name
#     TELEPORT_VERSION            = var.teleport_version
#     NODE_NAME                     = "${upper(var.project_name)}-${title(var.deployment)}-Proxy"
#     PROJECT_NAME                  = var.project_name
#     WAZUH_TOKEN                   = var.wazuh_token
#     WAZUH_URL                     = var.wazuh_url
#     WAZUH_GROUP                   = var.wazuh_group
#     INSTALL_GRAFANA               = local.enable_grafana
#     DEPLOYMENT_DOMAIN             = var.monitoring_domain
#     GRAFANA_USER                  = local.grafana_username
#     GRAFANA_PASSWORD              = local.grafana_password
#   }))

#   ## region3 region Agent User Data configuration
#   region3_agent_user_data = base64encode(templatefile("../userdata/agent_userdata.sh", {
#     IMAGE_TYPE                    = var.image_type
#     DEPLOYMENT_TYPE               = var.deployment_type
#     KASM_VERSION                = var.kasm_version
#     KASM_DOMAIN_NAME              = var.kasm_domain_name
#     KASM_MANAGER_TOKEN            = var.kasm_manager_token
#     PRIVATE_LB_HOSTNAME           = local.private_lb_urls[var.oci_regions[3]]
#     KASM_DOWNLOAD_URL             = var.kasm_download_url
#     ADDITIONAL_AGENT_INSTALL_ARGS = var.agent_additional_install_arguments
#     NGINX_CERT                    = var.nginx_cert
#     NGINX_KEY                     = var.nginx_key
#     NFS_ENABLED                   = var.deploy_nfs ? "1" : "0"
#     NFS_URL                       = local.nfs_url
#     NFS_PATH                      = var.nfs_profile_path
#     GPU_ENABLED                   = var.enable_gpu ? "1" : "0"
#     TELEPORT_TOKEN                = local.teleport_join_token
#     TELEPORT_CA                   = local.teleport_ca_pin
#     TELEPORT_DOMAIN_NAME          = local.teleport_domain_name
#     TELEPORT_VERSION            = var.teleport_version
#     NODE_NAME                     = "${upper(var.project_name)}-${title(var.deployment)}-Static-Agent"
#     PROJECT_NAME                  = var.project_name
#     WAZUH_TOKEN                   = var.wazuh_token
#     WAZUH_URL                     = var.wazuh_url
#     WAZUH_GROUP                   = var.wazuh_group
#     INSTALL_GRAFANA               = local.enable_grafana
#     DEPLOYMENT_DOMAIN             = var.monitoring_domain
#     GRAFANA_USER                  = local.grafana_username
#     GRAFANA_PASSWORD              = local.grafana_password
#   }))

#   ## Connection Proxy (CPX) User Data configuration
#   region3_cpx_user_data = base64encode(templatefile("../userdata/cpx_userdata.sh", {
#     IMAGE_TYPE                  = var.image_type
#     DEPLOYMENT_TYPE             = var.deployment_type
#     KASM_VERSION                = var.kasm_version
#     KASM_DOMAIN_NAME            = var.kasm_domain_name
#     PRIVATE_LB_HOSTNAME         = local.private_lb_urls[var.oci_regions[3]]
#     KASM_SERVICE_TOKEN          = var.kasm_service_token
#     KASM_DOWNLOAD_URL           = var.kasm_download_url
#     ADDITIONAL_CPX_INSTALL_ARGS = var.cpx_additional_install_arguments
#     KASM_ZONE_NAME              = var.oci_region_to_kasm_zone_map[var.oci_regions[3]]
#     TELEPORT_TOKEN              = local.teleport_join_token
#     TELEPORT_CA                 = local.teleport_ca_pin
#     TELEPORT_DOMAIN_NAME        = local.teleport_domain_name
#     TELEPORT_VERSION            = var.teleport_version
#     NODE_NAME                   = "${upper(var.project_name)}-${title(var.deployment)}-Connection-Proxy"
#     PROJECT_NAME                = var.project_name
#     WAZUH_TOKEN                 = var.wazuh_token
#     WAZUH_URL                   = var.wazuh_url
#     WAZUH_GROUP                 = var.wazuh_group
#     INSTALL_GRAFANA             = local.enable_grafana
#     DEPLOYMENT_DOMAIN           = var.monitoring_domain
#     GRAFANA_USER                = local.grafana_username
#     GRAFANA_PASSWORD            = local.grafana_password
#   }))

#   ## 1Password Secret creation
#   region3_op_secrets_contents = {
#     "${title(var.project_name)} ${title(var.deployment)} ${title(var.oci_regions[3])} Autoscale Config" = {
#       "section_values" = merge(
#         {
#           "SSH Public Key" = [
#             {
#               name  = "public_key"
#               value = local.agent_ssh_public_key
#             }
#           ],
#           "Agent Autoscale Config" = [
#             {
#               name  = "Agent Image id"
#               value = local.region3_image_ids["agent"]
#             },
#             {
#               name  = "Agent Public Subnet id"
#               value = local.region3_subnets["agent-public"].subnet_id
#             },
#             {
#               name  = "Agent Private Subnet id"
#               value = local.region3_subnets["agent-private"].subnet_id
#             },
#             {
#               name  = "Agent Security Group ID"
#               value = local.region3_nsgs["agent"][0]
#             },
#             {
#               name  = "Agent SSH Public Key"
#               value = local.agent_ssh_public_key
#             }
#           ],
#           "Windows Autoscale Config" = [
#             {
#               name  = "Windows Image id"
#               value = local.region3_image_ids["windows"]
#             },
#             {
#               name  = "Windows Public Subnet id"
#               value = local.region3_subnets["windows-public"].subnet_id
#             },
#             {
#               name  = "Windows Private Subnet id"
#               value = local.region3_subnets["windows-private"].subnet_id
#             },
#             {
#               name  = "Windows Security Group ID"
#               value = local.region3_nsgs["windows"][0]
#             },
#             {
#               name  = "Windows SSH Public Key"
#               value = local.agent_ssh_public_key
#             }
#           ],
#           "Autoscale Agent Config Override" = [
#             {
#               name  = "Agent Config Override"
#               value = <<OVERRIDE
#               {
#                   "launch_instance_details": {
#                       "defined_tags": {
#                           "customer_tags": {
#                               "Customer_name": "${var.customer_name}"
#                           }
#                       },
#                       "instance_options": {
#                           "OCI_MODEL_NAME": "InstanceOptions",
#                           "are_legacy_imds_endpoints_disabled": true
#                       },
#                       "agent_config": {
#                           "OCI_MODEL_NAME": "LaunchInstanceAgentConfigDetails",
#                           "is_monitoring_disabled": false,
#                           "is_management_disabled": false,
#                           "are_all_plugins_disabled": false,
#                           "plugins_config": [{
#                                   "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
#                                   "name": "Vulnerability Scanning",
#                                   "desired_state": "ENABLED"
#                               },
#                               {
#                                 "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
#                                 "name": "OS Management Service Agent",
#                                 "desired_state": "ENABLED"
#                               },
#                               {
#                                 "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
#                                 "name": "Compute Instance Run Command",
#                                 "desired_state": "ENABLED"
#                               },
#                               {
#                                 "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
#                                 "name": "Compute Instance Monitoring",
#                                 "desired_state": "ENABLED"
#                               },
#                               {
#                                 "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
#                                 "name": "Management Agent",
#                                 "desired_state": "ENABLED"
#                               }
#                           ]
#                       }
#                   }
#               }
#               OVERRIDE
#             }
#           ],
#           "Agent Custom Tags" = [
#             {
#               name  = "Agent Custom Tags"
#               value = <<TAGS
#               {
#                 "Deployment_type": "${var.deployment_type}",
#                 "Deployment": "${title(var.deployment)}",
#                 "Project_name": "${var.project_name}",
#                 "Deployed_by": "Kasm Autoscale",
#                 "Region": "${var.oci_regions[3]}"
#               }
#               TAGS
#             }
#           ],
#           "Startup Scripts" = [
#             {
#               name  = "Agent Startup Script"
#               value = "PLACEHOLDER"
#             },
#             {
#               name  = "Windows Startup Script"
#               value = local.region3_windows_user_data
#             }
#           ]
#         },
#         var.register_with_teleport ? {
#           "Autoscale Teleport Token" = [
#             {
#               name  = "Teleport Token"
#               value = local.autoscale_agent_teleport_join_token
#             },
#             {
#               name  = "Teleport CA Pin"
#               value = local.teleport_ca_pin
#             },
#           ]
#       } : {})
#     }
#   }
# }

# /*
#  * region 3 Outputs
#  */
# output "region3_vm_autoscale_settings" {
#   description = "Settings used for deployment to copy/paste for Agent autoscaling"
#   value       = <<AUTOSCALE
# Region: ${var.oci_regions[3]}
# Availability Domain: ${data.oci_identity_availability_domains.region3_ads.availability_domains[(length(data.oci_identity_availability_domains.region3_ads.availability_domains) - 1)].name}

# Agent:
# Agent image-id: ${local.region3_image_ids["agent"]}
# Agent Public subnet-id: ${local.region3_subnets["agent-public"].subnet_id}
# Agent Private subnet-id: ${local.region3_subnets["agent-private"].subnet_id}
# Security Group ID: ${local.region3_nsgs["agent"][0]}
# Windows:
# Windows image-id: ${local.region3_image_ids["windows"]}
# Windows Public subnet-id: ${local.region3_subnets["windows-public"].subnet_id}
# Windows Private subnet-id: ${local.region3_subnets["windows-private"].subnet_id}
# Security Group ID: ${local.region3_nsgs["windows"][0]}
# AUTOSCALE
# }

# output "region3_agent_custom_tags" {
#   description = "Custom Tags to use for the region 3 Agent Autoscale group"
#   value       = <<TAGS
# {
#   "Deployment_type": "${var.deployment_type}",
#   "Deployment": "${title(var.deployment)}",
#   "Project_name": "${var.project_name}",
#   "Deployed_by": "Kasm Autoscale",
#   "Region": "${var.oci_regions[3]}"
# }
# TAGS
# }
