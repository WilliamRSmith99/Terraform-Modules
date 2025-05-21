data "oci_identity_compartments" "compartment" {
  compartment_id            = var.tenancy_id
  compartment_id_in_subtree = var.is_child_compartment
  name                      = var.compartment_name
}

## Used to get Kasm custom image info
data "oci_identity_tenancy" "image" {
  count      = can(regex("(?i:^customerdeployments1$|^kasm$|^kasmhadeployments$)", var.image_compartment_name)) ? 1 : 0
  tenancy_id = var.tenancy_id
}

data "oci_identity_compartments" "image" {
  count                     = can(regex("(?i:^customerdeployments1$|^kasm$|^kasmhadeployments$)", var.image_compartment_name)) ? 0 : 1
  compartment_id            = var.tenancy_id
  name                      = var.image_compartment_name
  compartment_id_in_subtree = true
}

data "oci_identity_user" "kasm_user" {
  count   = var.user_id != "" ? 1 : 0
  user_id = var.user_id
}

data "oci_dns_zones" "zone" {
  compartment_id = local.compartment_id
  scope          = "PRIVATE"
  name           = local.private_domain_name
}

data "oci_dns_rrsets" "records" {
  zone_name_or_id = data.oci_dns_zones.zone.zones[0].id
  view_id         = data.oci_dns_zones.zone.zones[0].view_id
}

## 1Password keys lookup
data "onepassword_vault" "this" {
  for_each = local.op_passwords_to_import

  name = each.value.vault
}

data "onepassword_item" "secret" {
  for_each = local.op_passwords_to_import

  vault = data.onepassword_vault.this[each.key].uuid
  title = each.value.title
}