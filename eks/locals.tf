locals {
  helm_values = [{
    thanos = {

      objstoreConfig = {
        type = "S3"
        config = {
          bucket             = "${var.metrics_storage.bucket_id}"
          endpoint           = "s3.amazonaws.com" # Value explicitly specified by Thanos docs for Amazon S3 buckets
          region             = "${var.metrics_storage.region}"
          signature_version2 = false
          insecure           = false
        }
      }

      # These ServiceAccount annotations are what attaches the IAM role to the Thanos pods, giving them access to 
      # the S3 bucket.
      bucketweb = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = var.metrics_storage.iam_role_arn
          }
        }
      }
      compactor = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = var.metrics_storage.iam_role_arn
          }
        }
      }
      storegateway = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = var.metrics_storage.iam_role_arn
          }
        }
      }

    }
  }]
}
