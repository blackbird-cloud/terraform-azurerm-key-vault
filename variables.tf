variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Key Vault. Changing this forces a new resource to be created. The name must be globally unique. If the vault is in a recoverable state then the vault will need to be purged before reusing the name."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created."
}

variable "sku_name" {
  type        = string
  description = "(Optional) The Name of the SKU used for this Key Vault. Possible values are `standard` and `premium`. Defaults to `standard`."
  default     = "standard"
}

variable "enabled_for_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = false
}

variable "purge_protection_enabled" {
  type        = bool
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to `true`."
  default     = true
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Optional) Whether public network access is allowed for this Key Vault. Defaults to `true`."
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 90
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "access_policies" {
  type = map(object({
    object_id               = string
    tenant_id               = optional(string, "")
    application_id          = optional(string, null)
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default     = {}
  description = "(Optional) Manages a Key Vault Access Policy. A list of identities to grant permissions inside the Key Vault. `tenant_id` defaults to the current tenant."
}

variable "secrets" {
  type = map(object({
    name            = string
    value           = string
    content_type    = optional(string)
    expiration_date = optional(string)
    not_before_date = optional(string)
  }))
  default     = {}
  sensitive   = true
  description = "(Optional) A mapping of secrets to create within the Key Vault."
}

variable "keys" {
  type = map(object({
    name            = string
    key_type        = string
    key_opts        = list(string)
    key_size        = optional(string)
    curve           = optional(string)
    expiration_date = optional(string)
    not_before_date = optional(string)
    rotation_policy = optional(object({
      time_before_expiry   = optional(string)
      time_after_creation  = optional(string)
      expire_after         = optional(string)
      notify_before_expiry = optional(string)
    }))
  }))
  default     = {}
  description = "(Optional) A mapping of keys to create within the Key Vault."
}

variable "network_acls" {
  description = "(Optional) Network rules to apply to key vault."
  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })
  default = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}
