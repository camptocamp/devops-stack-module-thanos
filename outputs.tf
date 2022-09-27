output "id" {
  description = "ID to pass other modules in order to refer to this module as a dependency."
  value       = resource.null_resource.this.id
}

output "thanos_enabled" {
  description = "Flag to say that Thanos is enabled."
  value       = local.thanos.enabled
}
