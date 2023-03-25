locals {
  vm_list = yamldecode(file("${path.module}/vm.yml"))["vm"]
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "kubernetes_vms" {
  for_each = { for vm in local.vm_list : vm.name => vm }

  name                  = each.value.name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]
  size                  = try(each.value.size, "Standard_B1s")

  os_disk {
    name                 = format("%s-os-disk", each.value.name)
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = replace(each.value.name, "_", "-")
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.azureuser_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.kubernetes_storage_account.primary_blob_endpoint
  }
}