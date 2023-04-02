locals {
  use_managed_identity = var.metrics_storage.managed_identity_node_rg_name != null

  helm_values = [{
    # TODO check possible single merge call
    thanos = merge(local.use_managed_identity ? {
      commonLabels = {
        aadpodidbinding = "thanos"
      }
      } : null, {
      objstoreConfig = {
        type = "AZURE"
        config = merge({
          container       = var.metrics_storage.container
          storage_account = var.metrics_storage.storage_account
          }, local.use_managed_identity ? null : {
          storage_account_key = var.metrics_storage.storage_account_key
        })
      }
    })
    }, local.use_managed_identity ? {
    azureIdentity = {
      resourceID = azurerm_user_assigned_identity.thanos[0].id
      clientID   = azurerm_user_assigned_identity.thanos[0].client_id
    }
  } : null]
}
