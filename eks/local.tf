locals {
  # values.yaml translated into HCL structures.
  # Possible values available here -> https://github.com/bitnami/charts/tree/master/bitnami/thanos/
  helm_values = [{
    thanos = {

      objstoreConfig = local.bucket_config

      # This ServiceAccount annotations is what attaches the IAM role 
      # to the Thanos pods, giving them access to the S3 bucket.
      storegateway = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.iam_assumable_role_thanos.iam_role_arn
          }
        }
      }
      bucketweb = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.iam_assumable_role_thanos.iam_role_arn
          }
        }
      }

    }
  }]

  # Bucket configuration in an HCL structure that will be passed into
  # local.helm_values and then translated to YAML.
  # We added this as a local in order to then have an output to pass on to
  # other modules.
  bucket_config = {
    type = "S3"
    config = {
      bucket             = "${aws_s3_bucket.thanos_metrics_store.id}"
      endpoint           = "s3.amazonaws.com" # Value explicitly specified by Thanos docs for Amazon S3 buckets
      region             = "${aws_s3_bucket.thanos_metrics_store.region}"
      signature_version2 = false
      insecure           = false
    }
  }
}
