locals {
  iam_role_arn = var.metrics_storage.create_role ? module.iam_assumable_role_thanos.iam_role_arn : var.metrics_storage.iam_role_arn

  helm_values = [{
    thanos = {
      objstoreConfig = {
        type = "S3"
        config = {
          bucket             = "${data.aws_s3_bucket.thanos.id}"
          endpoint           = "s3.amazonaws.com" # Value explicitly specified by Thanos docs for Amazon S3 buckets
          region             = "${data.aws_s3_bucket.thanos.region}"
          signature_version2 = false
          insecure           = false
        }
      }

      # These ServiceAccount annotations are what attaches the IAM role to the Thanos pods, giving them access to 
      # the S3 bucket.
      bucketweb = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = local.iam_role_arn
          }
        }
      }
      compactor = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = local.iam_role_arn
          }
        }
      }
      storegateway = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = local.iam_role_arn
          }
        }
      }
    }
  }]
}
