terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
}

provider "azurerm" {
  alias           = "sub_b"
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  provider = azurerm.sub_b
  name     = "kv-rg"
  location = var.location
}

resource "azurerm_key_vault" "kv" {
  provider                 = azurerm.sub_b
  name                     = "mysecurevault1234-difu"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tenant_id                = var.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false
  enable_rbac_authorization = true

  # access_policy {
  #   tenant_id = var.tenant_id
  #   object_id = var.vm_identity_object_id  # <-- VM id from Subscription A
  #   secret_permissions = ["Get", "List"]
  # }
}
# az role assignment create \
#  --assignee "<principalId_of_VM>" \
#  --role "Key Vault Secrets User" \
#  --scope "/subscriptions/<subscription-B-id>/resourceGroups/<RG-Name>/providers/Microsoft.KeyVault/vaults/<KeyVault-Name>"

resource "azurerm_role_assignment" "vm_keyvault_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.vm_identity_object_id
  provider             = azurerm.sub_b
}

resource "azurerm_key_vault_secret" "example" {
  provider     = azurerm.sub_b
  name         = "example-secret"
  value        = "mySuperSecretValue"
  key_vault_id = azurerm_key_vault.kv.id
}