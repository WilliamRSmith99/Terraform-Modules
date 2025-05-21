resource "terraform_data" "wazuh_group" {

  input = {
    wazuh_url      = var.wazuh_url
    wazuh_username = var.wazuh_username
    wazuh_password = var.wazuh_password
    group_name     = var.group_name
  }



  provisioner "local-exec" {
    command     = "/bin/bash ./group_management.sh -a  -u ${var.wazuh_username} -p ${var.wazuh_password} -g ${var.group_name} -l ${var.wazuh_url}"
    when        = create
    working_dir = path.module
  }
  provisioner "local-exec" {
    command     = "/bin/bash ./group_management.sh -d  -u ${self.input.wazuh_username} -p ${self.input.wazuh_password} -g ${self.input.group_name} -l ${self.input.wazuh_url}"
    when        = destroy
    working_dir = path.module
  }

}

output "variables" {
  value = terraform_data.wazuh_group.input
}