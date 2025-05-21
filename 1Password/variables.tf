
variable "vault" {
  type        = string
  description = "Name of the 1 Password Vault to place/retrieve secrets"
}

variable "secret_name" {
  description = "The name of the secret to be created"
  type        = string
}
variable "secret_url" {
  description = "The name of the secret to be created"
  type        = string
  default     = ""
}
variable "username" {
  description = "the credential username prefix"
  type        = string
  default     = ""
}
variable "password" {
  description = "the credential password"
  type        = string
  default     = ""
}

variable "tags" {
  type        = list(string)
  description = "Tags to be generated for op entry"
  default     = null
}

variable "section_values" {
  description = "The secret values to be exported into 1Password"
  default     = {}
  type = map(list(object({
    name  = string
    value = string
  })))
}