resource "onepassword_item" "Deployment_keys" {
  vault = var.vault

  title    = var.secret_name
  category = "login"
  tags     = var.tags
  url      = var.secret_url
  username = var.username
  password = var.password

  dynamic "section" {
    for_each = var.section_values
    content {
      label = section.key
      dynamic "field" {
        for_each = var.section_values[section.key]
        content {
          label = field.value.name
          type  = "STRING"
          value = field.value.value
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      vault
    ]
  }
}
