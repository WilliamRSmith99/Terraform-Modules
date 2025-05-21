locals {
  # Compartment
  compartment_id       = data.oci_identity_compartments.compartment.compartments[0].id
  image_compartment_id = can(regex("(?i:^customerdeployments1$|^kasm$|^kasmhadeployments$)", var.image_compartment_name)) ? data.oci_identity_tenancy.image[0].id : data.oci_identity_compartments.image[0].compartments[0].id

  ## Agent public IP
  agent_public_ip = var.static_agent_nat_gateway ? false : true

  ## Private DNS domain name
  private_domain_name = var.parent_domain_name == "" ? "private.${var.kasm_domain_name}" : "private.${var.parent_domain_name}"
  nfs_url             = "${lower(var.deployment)}-nfs.${local.private_domain_name}"

  ## Get Private Load Balancer URLs for Agent and CPX connections
  private_lb_urls = { for region in var.oci_regions : region =>
    flatten([for domain in data.oci_dns_rrsets.records.rrsets[*].domain : domain if can(regex("${region}.${var.deployment}", domain))])[0]
  }

  deployment_strategy_tag = join("-", [for strategy in var.deployment_strategy : title(strategy)])
  ## Freeform Tags to apply to all Compartment resources for this deployment
  freeform_tags = merge(var.freeform_tags, {
    Deployed_by         = "Terraform"
    Managed_by          = "${title(var.deployment)} - 07-compute"
    Created_by          = var.instance_principal == "" ? data.oci_identity_user.kasm_user[0].name : var.instance_principal
    Project_name        = var.project_name
    Deployment_strategy = local.deployment_strategy_tag
    Deployment_type     = title(var.deployment_type)
    Kasm_Version        = var.kasm_version
  })

  defined_tags = merge(var.defined_tags, {
    "customer_tags.Customer_name" = var.customer_name
  })

  ## 1Password
  op_passwords_to_import = {
    kasm = {
      title = "${title(var.project_name)} ${title(var.deployment)} Other Credential",
      vault = "Customer-Deployments"
    },
    wazuh = {
      title = "Wazuh Agent Password",
      vault = "Engineering"
    },
    ssh_keys = {
      title = "${title(var.project_name)} ${title(var.deployment)} SSH Keys",
      vault = "Engineering"
    },
    route_53 = {
      title = "AWS - Terraform Route53 Role",
      vault = "IaaS-Cloud-Accounts"
    },
    grafana_creds = {
      title = "Grafana Terraform Credentials",
      vault = "IaaS-Cloud-Accounts"
    }

  }

  kasm_creds_imports = merge({
    for index, section in data.onepassword_item.secret["kasm"].section : section.label => {
      for index, field in section.field : field.label => field.value
    }
  })

  ssh_key_imports = merge({
    for index, section in data.onepassword_item.secret["ssh_keys"].section : section.label => {
      for index, field in section.field : field.label => field.value
    }
  })

  route53_access_key        = var.aws_access_key == "" ? data.onepassword_item.secret["route_53"].username : var.aws_access_key
  route53_secret_key        = var.aws_secret_key == "" ? data.onepassword_item.secret["route_53"].password : var.aws_secret_key
  wazuh_token               = var.wazuh_token == "" ? data.onepassword_item.secret["wazuh"].password : var.wazuh_token
  kasm_database_password    = var.kasm_database_password == "" ? local.kasm_creds_imports["Database Credential"].token : var.kasm_database_password
  kasm_redis_password       = var.kasm_redis_password == "" ? local.kasm_creds_imports["Redis Credential"].token : var.kasm_redis_password
  kasm_manager_token        = var.kasm_manager_token == "" ? local.kasm_creds_imports["Manager Credential"].token : var.kasm_manager_token
  kasm_service_token        = var.kasm_service_token == "" ? local.kasm_creds_imports["Service Credential"].token : var.kasm_service_token
  management_ssh_public_key = var.ssh_public_keys.management == "" ? local.ssh_key_imports["Management SSH Keys"].management_public_key : var.ssh_public_keys.management
  agent_ssh_public_key      = var.ssh_public_keys.agent == "" ? local.ssh_key_imports["Agent SSH Keys"].agent_public_key : var.ssh_public_keys.agent

  ## Monitoring Configs
  enable_grafana   = var.enable_grafana == true ? "1" : "0"
  grafana_username = var.enable_grafana == true ? var.grafana_username == "" ? data.onepassword_item.secret["grafana_creds"].username : var.grafana_username : "null"
  grafana_password = var.enable_grafana == true ? var.grafana_password == "" ? data.onepassword_item.secret["grafana_creds"].password : var.grafana_password : "null"

  ## Create list of AD zones for autoscale config
  oci_ad_zones             = data.oci_identity_availability_domains.management_ads.availability_domains[(length(data.oci_identity_availability_domains.management_ads.availability_domains) - 1)].name
  oci_availability_domains = [for index in range(tonumber(split("-", local.oci_ad_zones)[4]), 0, -1) : "${join("-", slice(split("-", local.oci_ad_zones), 0, 3))}-${index}"]

  op_secrets_contents = {
    "${title(var.project_name)} ${title(var.deployment)} ${title(var.oci_regions[0])} Autoscale Config" = {
      "section_values" = merge(
        {
          "SSH Public Key" = [
            {
              name  = "public_key"
              value = local.agent_ssh_public_key
            }
          ],
          "Agent Autoscale Config" = [
            {
              name  = "Agent Image id"
              value = local.management_image_ids["agent"]
            },
            {
              name  = "Agent Public Subnet id"
              value = local.management_subnets["agent-public"].subnet_id
            },
            {
              name  = "Agent Private Subnet id"
              value = local.management_subnets["agent-private"].subnet_id
            },
            {
              name  = "Agent Security Group ID"
              value = "[\"${local.management_nsgs["agent"][0]}\"]"
            },
            {
              name  = "Agent SSH Public Key"
              value = var.ssh_public_keys.agent
            }
          ],
          "Windows Autoscale Config" = [
            {
              name  = "Windows Image id"
              value = local.management_image_ids["windows"]
            },
            {
              name  = "Windows Public Subnet id"
              value = local.management_subnets["windows-public"].subnet_id
            },
            {
              name  = "Windows Private Subnet id"
              value = local.management_subnets["windows-private"].subnet_id
            },
            {
              name  = "Windows Security Group ID"
              value = "[\"${local.management_nsgs["windows"][0]}\"]"
            },
            {
              name  = "Windows SSH Public Key"
              value = var.ssh_public_keys.agent
            }
          ],
          "Autoscale Agent Config Override" = [
            {
              name  = "Agent Config Override"
              value = <<OVERRIDE
              {
                  "launch_instance_details": {
                      "defined_tags": {
                          "customer_tags": {
                              "Customer_name": "${var.customer_name}"
                          }
                      },
                      "instance_options": {
                          "OCI_MODEL_NAME": "InstanceOptions",
                          "are_legacy_imds_endpoints_disabled": true
                      },
                      "agent_config": {
                          "OCI_MODEL_NAME": "LaunchInstanceAgentConfigDetails",
                          "is_monitoring_disabled": false,
                          "is_management_disabled": false,
                          "are_all_plugins_disabled": false,
                          "plugins_config": [{
                                  "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
                                  "name": "Vulnerability Scanning",
                                  "desired_state": "ENABLED"
                              },
                              {
                                "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
                                "name": "OS Management Service Agent",
                                "desired_state": "ENABLED"
                              },
                              {
                                "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
                                "name": "Compute Instance Run Command",
                                "desired_state": "ENABLED"
                              },
                              {
                                "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
                                "name": "Compute Instance Monitoring",
                                "desired_state": "ENABLED"
                              },
                              {
                                "OCI_MODEL_NAME": "InstanceAgentPluginConfigDetails",
                                "name": "Management Agent",
                                "desired_state": "ENABLED"
                              }
                          ]
                      }
                  }
              }
              OVERRIDE
            }
          ],
          "Agent Custom Tags" = [
            {
              name  = "Agent Custom Tags"
              value = <<TAGS
              {
                "Deployment_type": "${var.deployment_type}",
                "Deployment": "${title(var.deployment)}",
                "Project_name": "${var.project_name}",
                "Deployed_by": "Kasm Autoscale",
                "Region": "${var.oci_regions[0]}"
              }
              TAGS
            }
          ],
          "Startup Scripts" = [
            {
              name  = "Agent Startup Script"
              value = local.management_autoscale_user_data
            },
            {
              name  = "Windows Startup Script"
              value = local.management_windows_user_data
            }
          ],
          "Instance Configs" = [
            {
              name  = "Region"
              value = var.oci_regions[0]
            },
            {
              name  = "Availability Domain"
              value = jsonencode(local.oci_availability_domains)

              # <<ZONES
              # [
              # %{ for zone in local.oci_availability_domains}
              # "${zone}",
              # %{ endfor }
              # ]
              # ZONES
            },
            {
              name  = "Shape"
              value = "VM.Standard.E4.Flex"
            }
          ]
        },
        var.register_with_teleport ? {
          "Autoscale Teleport Token" = [
            {
              name  = "Teleport Token"
              value = local.autoscale_agent_teleport_join_token
            },
            {
              name  = "Teleport CA Pin"
              value = local.teleport_ca_pin
            },
          ]
      } : {})
    }
  }


}