resource "random_string" "resource_code" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = format("tfstate%s", terraform.workspace)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "terraform"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
