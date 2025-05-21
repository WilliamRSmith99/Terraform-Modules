terraform {
  required_version = "~> 1.0"
  # backend "s3" {
  #   bucket                      = "terraform-customer-deployment-state-files"
  #   key                         = "<project_or_customer_name>/07-compute/<deployment>/terraform.tfstate"
  #   region                      = "us-ashburn-1"
  #   shared_credentials_files    = ["../s3_creds.tfvars"]
  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   skip_requesting_account_id  = true
  #   use_path_style              = true
  #   skip_s3_checksum            = true
  #   skip_metadata_api_check = true
  #   endpoints = {
  #     s3 = "https://idbxovo8w3ee.compat.objectstorage.us-ashburn-1.oraclecloud.com"
  #   }
  # }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    teleport = {
      source  = "terraform.releases.teleport.dev/gravitational/teleport"
      version = "~> 14.0"
    }
    command = {
      source  = "hkak03key/command"
      version = "~> 0.1"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  access_key = local.route53_access_key
  secret_key = local.route53_secret_key
  region     = var.aws_region
}
