<!-- BEGIN_TF_DOCS -->
# Terraform Azurerm Key Vault Module
Terraform module to create an Azure Key Vault

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://blackbird.cloud)

## Example
```hcl

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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.8 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | (Optional) Manages a Key Vault Access Policy. A list of identities to grant permissions inside the Key Vault. `tenant_id` defaults to the current tenant. | <pre>map(object({<br/>    object_id               = string<br/>    tenant_id               = optional(string, "")<br/>    application_id          = optional(string, null)<br/>    certificate_permissions = optional(list(string), [])<br/>    key_permissions         = optional(list(string), [])<br/>    secret_permissions      = optional(list(string), [])<br/>    storage_permissions     = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | (Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | (Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | (Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_keys"></a> [keys](#input\_keys) | (Optional) A mapping of keys to create within the Key Vault. | <pre>map(object({<br/>    name            = string<br/>    key_type        = string<br/>    key_opts        = list(string)<br/>    key_size        = optional(string)<br/>    curve           = optional(string)<br/>    expiration_date = optional(string)<br/>    not_before_date = optional(string)<br/>    rotation_policy = optional(object({<br/>      time_before_expiry   = optional(string)<br/>      time_after_creation  = optional(string)<br/>      expire_after         = optional(string)<br/>      notify_before_expiry = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Key Vault. Changing this forces a new resource to be created. The name must be globally unique. If the vault is in a recoverable state then the vault will need to be purged before reusing the name. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | (Optional) Network rules to apply to key vault. | <pre>object({<br/>    bypass                     = string,<br/>    default_action             = string,<br/>    ip_rules                   = list(string),<br/>    virtual_network_subnet_ids = list(string),<br/>  })</pre> | <pre>{<br/>  "bypass": "AzureServices",<br/>  "default_action": "Deny",<br/>  "ip_rules": [],<br/>  "virtual_network_subnet_ids": []<br/>}</pre> | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Optional) Whether public network access is allowed for this Key Vault. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | (Optional) Is Purge Protection enabled for this Key Vault? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | (Optional) A mapping of secrets to create within the Key Vault. | <pre>map(object({<br/>    name            = string<br/>    value           = string<br/>    content_type    = optional(string)<br/>    expiration_date = optional(string)<br/>    not_before_date = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The Name of the SKU used for this Key Vault. Possible values are `standard` and `premium`. Defaults to `standard`. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | (Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | `number` | `90` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keys"></a> [keys](#output\_keys) | The keys in the vault |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | The secrets in the vault |
| <a name="output_vault"></a> [vault](#output\_vault) | The created Key Vault. |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2025 [Blackbird Cloud](https://blackbird.cloud)
<!-- END_TF_DOCS -->