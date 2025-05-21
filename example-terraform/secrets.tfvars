/*
 *  1Password credentials to use for retrieving and uploading secrets
 */
# one_password_token = ""

# /*
#  * All Secrets below this line are OPTIONAL and will be pulled from 1Password if blank
#  */
### Use these variables to statically assign Kasm passwords
# kasm_admin_password          = ""
# kasm_user_password           = ""
# kasm_database_password       = ""
# kasm_redis_password          = ""
# kasm_manager_token           = ""
# kasm_service_token           = ""
# kasm_siteadmin_password      = ""
# kasm_workspaceadmin_password = ""
# kasm_system_password         = ""

### Use these variables to statically assign monitoring credentials
# grafana_username             = ""
# grafana_password             = ""

### Use This to statically assign SSH credentials
# ssh_public_keys = {
#     management = ""
#     agent      = ""
# }

/*
 * Place TLS certificates for Kasm agents - if you are using Direct-to-Agent
 * where appropriate below. These should be the TLS Full chain and the TLS
 * Private keys. If you generated these keys in the 01-compartment stage, from
 * the CLI, navigate back to that folder and run the following command to get
 * the keys:
 *  - For the PROD keys:
 *   user@tf-host$ terraform output -json | jq -r '.direct_to_agent_ssl_certs.value.prod.fullchain' > fullchain.bak
 *
 *  - For the STAGING keys:
 *   user@tf-host$ terraform output -json | jq -r '.direct_to_agent_ssl_certs.value.stage.private_key' > privkey.bak
 *
 * From there, you will have the TLS Fullchain and Private keys to paste into the variables below.
 */

# nginx_cert = <<PUBLICCERT
# Place TLS Full Chain here without quotes or \n characters
# PUBLICCERT

# nginx_key = <<PRIVATEKEY
# Place TLS Private Key here without quotes or \n characters
# PRIVATEKEY
