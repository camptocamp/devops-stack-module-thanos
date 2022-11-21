locals {
  helm_values = [{
    thanos = {

      objstoreConfig = {
        type = "AZURE"
        config = {
          storage_account     = "${local.thanos.metrics_storage.storage_account}"
          storage_account_key = "${local.thanos.metrics_storage.storage_account_key}"
          container           = "${local.thanos.metrics_storage.container}"
        }
      }

    }
  }]

  thanos_defaults = {}

  thanos = merge(
    local.thanos_defaults,
    var.thanos,
  )
}
