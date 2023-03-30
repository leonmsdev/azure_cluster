resource "azurerm_key_vault_access_policy" "git-hub-access" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_ad_service_principal.example.id

  secret_permissions = [
    "get",
  ]

  key_permissions = [
    "decrypt",
  ]
}