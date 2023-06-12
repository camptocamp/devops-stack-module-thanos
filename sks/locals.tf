locals {
  helm_values = [{
    thanos = {
      clusterDomain = "${var.cluster_id}.cluster.local"
      objstoreConfig = {
        type = "S3"
        config = {
          bucket     = "${var.metrics_storage.bucket_name}"
          endpoint   = "sos-${var.metrics_storage.region}.exo.io"
          access_key = "${var.metrics_storage.access_key}"
          secret_key = "${var.metrics_storage.secret_key}"
        }
      }
    }
  }]
}
