output "id" {
  value = module.thanos.id
}

output "bucket_config" {
  value = local.bucket_config
}

output "iam_role_arn" {
  value = module.iam_assumable_role_thanos.iam_role_arn
}
