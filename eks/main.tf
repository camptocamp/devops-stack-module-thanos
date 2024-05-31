data "aws_s3_bucket" "thanos" {
  bucket = var.metrics_storage.bucket_id
}

data "aws_iam_policy_document" "thanos" {
  count = var.metrics_storage.create_role ? 1 : 0

  statement {
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      data.aws_s3_bucket.thanos.arn,
      format("%s/*", data.aws_s3_bucket.thanos.arn),
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "thanos" {
  count = var.metrics_storage.create_role ? 1 : 0

  name_prefix = "thanos-s3-"
  description = "Thanos IAM policy for accessing the S3 bucket named ${data.aws_s3_bucket.thanos.id}"
  policy      = data.aws_iam_policy_document.thanos[0].json
}

module "iam_assumable_role_thanos" {
  source                     = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                    = "~> 5.0"
  create_role                = var.metrics_storage.create_role
  number_of_role_policy_arns = 1
  role_name_prefix           = "thanos-s3-"
  provider_url               = try(trimprefix(var.metrics_storage.cluster_oidc_issuer_url, "https://"), "")
  role_policy_arns           = [try(resource.aws_iam_policy.thanos[0].arn, null)]

  # List of ServiceAccounts that have permission to attach to this IAM role
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:thanos:thanos-bucketweb",
    "system:serviceaccount:thanos:thanos-storegateway",
    "system:serviceaccount:thanos:thanos-compactor",
  ]
}

module "thanos" {
  source = "../"

  cluster_name           = var.cluster_name
  base_domain            = var.base_domain
  subdomain              = var.subdomain
  argocd_project         = var.argocd_project
  argocd_labels          = var.argocd_labels
  destination_cluster    = var.destination_cluster
  target_revision        = var.target_revision
  cluster_issuer         = var.cluster_issuer
  deep_merge_append_list = var.deep_merge_append_list
  enable_service_monitor = var.enable_service_monitor
  app_autosync           = var.app_autosync
  dependency_ids         = var.dependency_ids
  network_policy_thanos  = var.network_policy_thanos

  resources = var.resources

  thanos = var.thanos

  helm_values = concat(local.helm_values, var.helm_values)
}
