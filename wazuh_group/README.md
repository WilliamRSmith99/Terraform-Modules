# wazuh_group

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform_data.wazuh_group](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | User OCID for autoscaling | `string` | n/a | yes |
| <a name="input_wazuh_password"></a> [wazuh\_password](#input\_wazuh\_password) | Password of Wazuh API User | `string` | n/a | yes |
| <a name="input_wazuh_url"></a> [wazuh\_url](#input\_wazuh\_url) | url of Wazuh server | `string` | n/a | yes |
| <a name="input_wazuh_username"></a> [wazuh\_username](#input\_wazuh\_username) | Username of Wazuh API User | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_variables"></a> [variables](#output\_variables) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
