locals {
  helm_values = [{
    # TODO check possible single merge call
    thanos = merge(var.metrics_storage.use_managed_identity.enabled ? {
      commonLabels = {
        aadpodidbinding = "thanos"
      }
      } : null, {
      objstoreConfig = {
        type = "AZURE"
        config = merge({
          container       = var.metrics_storage.container
          storage_account = var.metrics_storage.storage_account
          }, var.metrics_storage.use_managed_identity.enabled ? null : {
          storage_account_key = var.metrics_storage.storage_account_key
        })
      }
    })
    }, var.metrics_storage.use_managed_identity.enabled ? {
    azureIdentity = {
      resourceID = azurerm_user_assigned_identity.thanos[0].id
      clientID   = azurerm_user_assigned_identity.thanos[0].client_id
    }
  } : null]
}
