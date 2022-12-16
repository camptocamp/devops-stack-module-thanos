locals {
  helm_values = [{
    thanos = {
      objstoreConfig = {
        type = "AZURE"
        config = {
          container           = "${var.metrics_storage.container}"
          storage_account     = "${var.metrics_storage.storage_account}"
          storage_account_key = "${var.metrics_storage.storage_account_key}"
        }
      }
    }
  }]
}
