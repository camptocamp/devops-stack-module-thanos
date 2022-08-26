output "id" {
  value = resource.null_resource.this.id
}

output "thanos_enabled" {
  value = local.thanos.enabled
}
