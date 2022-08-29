locals {
  # values.yaml translated into HCL structures.
  # Possible values available here -> https://github.com/bitnami/charts/tree/master/bitnami/thanos/
  helm_values = [{
    thanos = {

      objstoreConfig = {
        type = "S3"
        config = {
          bucket             = "${aws_s3_bucket.thanos_metrics_store.id}"
          endpoint           = "s3.amazonaws.com" # Value explicitly specified by Thanos docs for Amazon S3 buckets
          region             = "${aws_s3_bucket.thanos_metrics_store.region}"
          signature_version2 = false
          insecure           = false
        }
      }

      # These ServiceAccount annotations are what attaches the IAM role 
      # to the Thanos pods, giving them access to the S3 bucket.
      bucketweb = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.iam_assumable_role_thanos.iam_role_arn
          }
        }
      }
      compactor = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.iam_assumable_role_thanos.iam_role_arn
          }
        }
      }
      storegateway = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.iam_assumable_role_thanos.iam_role_arn
          }
        }
      }

    }
  }]

  # Bucket configuration in an HCL structure that will be used as an output
  # to pass on to kube-prometheus-stack and then configure thanos-sidecar.
  metrics_archives = {
    # This is set as true, because if we call this module it forcefully
    # means Thanos is activated. This variable is only needed to create
    # the Kubernetes secret with the bucket information in the module
    # kube-prometheus-stack.
    thanos_enabled = true

    bucket_config = {
      type = "s3"
      config = {
        bucket   = "${aws_s3_bucket.thanos_metrics_store.id}"
        endpoint = "s3.${aws_s3_bucket.thanos_metrics_store.region}.amazonaws.com"
      }
    }

    iam_role_arn = module.iam_assumable_role_thanos.iam_role_arn
  }
}
