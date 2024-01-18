locals {
  use_managed_identity = var.metrics_storage.managed_identity_node_rg_name != null

  helm_values = [{
    thanos = merge(local.use_managed_identity ? {

      bucketweb = {
        podLabels = {
          "azure.workload.identity/use" = "true"
        }
        serviceAccount = {
          annotations = {
            "azure.workload.identity/client-id" = azurerm_user_assigned_identity.thanos[0].client_id
          }
        }
      }
      compactor = {
        podLabels = {
          "azure.workload.identity/use" = "true"
        }
        serviceAccount = {
          annotations = {
            "azure.workload.identity/client-id" = azurerm_user_assigned_identity.thanos[0].client_id
          }
        }
      }
      storegateway = {
        podLabels = {
          "azure.workload.identity/use" = "true"
        }
        serviceAccount = {
          annotations = {
            "azure.workload.identity/client-id" = azurerm_user_assigned_identity.thanos[0].client_id
          }
        }
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
  }]
}
