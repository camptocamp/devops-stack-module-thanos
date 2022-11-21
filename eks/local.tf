locals {
  # values.yaml translated into HCL structures.
  # Possible values available here -> https://github.com/bitnami/charts/tree/master/bitnami/thanos/
  helm_values = [{
    thanos = {

      objstoreConfig = {
        type = "S3"
        config = {
          bucket             = "${local.thanos.metrics_storage.bucket}"
          endpoint           = "s3.amazonaws.com" # Value explicitly specified by Thanos docs for Amazon S3 buckets
          region             = "${local.thanos.metrics_storage.region}"
          signature_version2 = false
          insecure           = false
        }
      }

      # These ServiceAccount annotations are what attaches the IAM role to the Thanos pods, giving them access to 
      # the S3 bucket.
      bucketweb = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = local.thanos.metrics_storage.iam_role_arn
          }
        }
      }
      compactor = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = local.thanos.metrics_storage.iam_role_arn
          }
        }
      }
      storegateway = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = local.thanos.metrics_storage.iam_role_arn
          }
        }
      }

    }
  }]

  thanos_defaults = {
    metrics_storage = {
      bucket       = null
      region       = null
      iam_role_arn = null
    }
  }

  thanos = merge(
    local.thanos_defaults,
    var.thanos,
  )
}
