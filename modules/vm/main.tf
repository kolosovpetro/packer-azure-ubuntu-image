resource "azurerm_public_ip" "public" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
}

data "azurerm_image" "search" {
  name                = var.storage_image_reference_sku
  resource_group_name = var.image_resource_group_name
}

resource "azurerm_virtual_machine" "public" {
  name                  = var.vm_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.public.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    id = data.azurerm_image.search.id
  }

  storage_os_disk {
    name              = var.storage_os_disk_name
    caching           = var.storage_os_disk_caching
    create_option     = var.storage_os_disk_create_option
    managed_disk_type = var.storage_os_disk_managed_disk_type
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.os_profile_admin_username}/.ssh/authorized_keys"
      key_data = file(var.os_profile_admin_public_key_path)
    }
  }

  os_profile {
    computer_name  = var.os_profile_computer_name
    admin_username = var.os_profile_admin_username
  }

  depends_on = [
    azurerm_network_interface_security_group_association.public
  ]
}
