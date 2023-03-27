variable "metrics_storage" {
  description = "Azure metrics storage configuration"
  type = object({
    container       = string
    storage_account = string
    use_managed_identity = object({
      enabled      = bool
      node_rg_name = optional(string, null)
    })
    storage_account_key = optional(string, null)
  })

  validation {
    condition     = var.metrics_storage.use_managed_identity.enabled == (var.metrics_storage.storage_account_key == null)
    error_message = "Setting storage_account_key and using a managed identity are mutually exclusive."
  }

  validation {
    condition     = var.metrics_storage.use_managed_identity.enabled == (var.metrics_storage.use_managed_identity.node_rg_name != null)
    error_message = "use_managed_identity.node_rg_name must only be set when using a managed identity."
  }
}
