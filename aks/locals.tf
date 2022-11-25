locals {
  helm_values = [{
    thanos = {
      objstoreConfig = {
        type = "AZURE"
        config = {
          container           = "${var.metrics_storage.container_name}"
          storage_account     = "${var.metrics_storage.storage_account_name}"
          storage_account_key = "${var.metrics_storage.storage_account_key}"
        }
      }
    }
  }]
}
