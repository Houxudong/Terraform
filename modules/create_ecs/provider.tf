terraform {
  required_version = ">= 0.14"
  required_providers {
    ecloud = {
      source  = "ecloud/ecloud"
      version = "= 1.0.8"
    }
  }
}


provider "ecloud" {
  access_key = var.ak
  secret_key = var.sk
  region     = "CIDC-RP-29"
}