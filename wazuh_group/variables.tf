variable "group_name" {
  description = "User OCID for autoscaling"
  type        = string
}

variable "wazuh_url" {
  description = "url of Wazuh server"
  type        = string
}
variable "wazuh_username" {
  description = "Username of Wazuh API User"
  type        = string
}
variable "wazuh_password" {
  description = "Password of Wazuh API User"
  type        = string
}
