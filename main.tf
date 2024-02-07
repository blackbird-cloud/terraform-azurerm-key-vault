data "azurerm_client_config" "current" {}

locals {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault" "default" {
  tenant_id = local.tenant_id

  name                            = var.name
  sku_name                        = var.sku_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_deployment          = var.enabled_for_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  public_network_access_enabled   = var.public_network_access_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  tags                            = var.tags
  network_acls {
    default_action             = var.network_acls.default_action
    bypass                     = var.network_acls.bypass
    ip_rules                   = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }

  dynamic "access_policy" {
    for_each = var.access_policies

    content {
      tenant_id               = access_policy.value.tenant_id == "" ? local.tenant_id : access_policy.value.tenant_id
      object_id               = access_policy.value.object_id
      application_id          = access_policy.value.application_id
      certificate_permissions = access_policy.value.certificate_permissions
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }
}

resource "azurerm_key_vault_secret" "default" {
  for_each = nonsensitive(var.secrets)

  key_vault_id = azurerm_key_vault.default.id
  tags         = var.tags

  name            = each.value.name
  value           = each.value.value
  content_type    = each.value.content_type
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date
}

resource "azurerm_key_vault_key" "default" {
  for_each = var.keys

  key_vault_id = azurerm_key_vault.default.id
  tags         = var.tags

  name            = each.value.name
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  curve           = each.value.curve
  key_opts        = each.value.key_opts
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date

  dynamic "rotation_policy" {
    for_each = each.value.rotation_policy == null ? {} : { each.value.name = each.value.rotation_policy }

    content {
      automatic {
        time_before_expiry  = rotation_policy.value.time_before_expiry
        time_after_creation = rotation_policy.value.time_after_creation
      }

      expire_after         = rotation_policy.value.expire_after
      notify_before_expiry = rotation_policy.value.notify_before_expiry
    }
  }
}
