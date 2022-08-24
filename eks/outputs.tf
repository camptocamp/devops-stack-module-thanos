output "id" {
  value = module.thanos.id
}

output "metrics_archives" {
  value = local.metrics_archives
}
