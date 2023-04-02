variable "metrics_storage" {
  description = "Azure metrics storage configuration"
  type = object({
    container       = string
    storage_account = string
    managed_identity_node_rg_name = optional(string, null)
    storage_account_key = optional(string, null)
  })

  validation {
    condition     = (var.metrics_storage.managed_identity_node_rg_name == null) != (var.metrics_storage.storage_account_key == null)
    error_message = "You must set one (and only one) of these attributes: managed_identity_node_rg_name, storage_account_key."
  }
}
