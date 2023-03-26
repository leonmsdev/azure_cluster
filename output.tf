output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "tls_private_key" {
  value     = tls_private_key.azureuser_ssh.private_key_pem
  sensitive = true
}


output "terraform-space" {
  value = terraform.workspace
}