packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "azure-client-id" {
  type = string
}

variable "azure-client-secret" {
  type = string
}

variable "azure-region" {
  type = string
}

variable "azure-resource-group" {
  type = string
}

variable "azure-subscription-id" {
  type = string
}

variable "azure-tenant-id" {
  type = string
}

variable "vm-size" {
  type = string
}

variable "image-name" {
  type = string
}

source "azure-arm" "autogenerated_1" {
  client_id                         = "${var.azure-client-id}"
  client_secret                     = "${var.azure-client-secret}"
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "${var.azure-region}"
  managed_image_name                = "${var.image-name}"
  managed_image_resource_group_name = "${var.azure-resource-group}"
  os_type                           = "Linux"
  subscription_id                   = "${var.azure-subscription-id}"
  tenant_id                         = "${var.azure-tenant-id}"
  vm_size                           = "${var.vm-size}"
}

build {
  sources = ["source.azure-arm.autogenerated_1"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    script          = "scripts/provision.sh"
  }
}
