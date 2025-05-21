# ssh_keys

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_onepassword"></a> [onepassword](#requirement\_onepassword) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_onepassword"></a> [onepassword](#provider\_onepassword) | ~> 1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [onepassword_item.Deployment_keys](https://registry.terraform.io/providers/1Password/onepassword/latest/docs/resources/item) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_password"></a> [password](#input\_password) | the credential password | `string` | `""` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The name of the secret to be created | `string` | n/a | yes |
| <a name="input_secret_url"></a> [secret\_url](#input\_secret\_url) | The name of the secret to be created | `string` | `""` | no |
| <a name="input_section_values"></a> [section\_values](#input\_section\_values) | The secret values to be exported into 1Password | <pre>map(list(object({<br>    name  = string<br>    value = string<br>  })))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be generated for op entry | `list(string)` | `null` | no |
| <a name="input_username"></a> [username](#input\_username) | the credential username prefix | `string` | `""` | no |
| <a name="input_vault"></a> [vault](#input\_vault) | Name of the 1 Password Vault to place/retrieve secrets | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
