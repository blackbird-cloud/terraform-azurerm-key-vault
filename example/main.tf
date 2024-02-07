
module "azurerm_key_vault" {
  source  = "blackbird-cloud/key-vault/azurerm"
  version = "~> 1"

  name                          = "example-key-vault"
  location                      = "westeurope"
  resource_group_name           = "example-rg"
  soft_delete_retention_days    = 7
  enable_rbac_authorization     = false
  public_network_access_enabled = true
  access_policies = {
    admins = {
      object_id = "uuid"
      key_permissions = [
        "Decrypt",
        "Get",
        "List",
        "Sign",
        "UnwrapKey",
        "Verify",
        "GetRotationPolicy",
      ]
      secret_permissions = [
        "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
      ]
    }
  }
}
