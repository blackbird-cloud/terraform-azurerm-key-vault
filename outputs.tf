output "vault" {
  value       = azurerm_key_vault.default
  description = "The created Key Vault."
}

output "secrets" {
  sensitive   = true
  value       = azurerm_key_vault_secret.default
  description = "The secrets in the vault"
}

output "keys" {
  value       = azurerm_key_vault_key.default
  description = "The keys in the vault"
}
