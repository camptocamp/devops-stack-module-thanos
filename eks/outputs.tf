output "id" {
  value = module.thanos.id
}

output "metrics_archives" {
  description = "value"
  value = local.metrics_archives
}

output "thanos_enabled" {
  description = "value"
  value = module.thanos.thanos_enabled
}
