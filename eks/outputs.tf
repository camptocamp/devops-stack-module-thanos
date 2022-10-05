output "id" {
  description = "ID to pass other modules in order to refer to this module as a dependency. It takes the ID that comes from the main module and passes it along to the code that called this variant in the first place."
  value       = module.thanos.id
}

output "metrics_archives" {
  description = "Bucket configuration in an HCL structure that will be used as an output to pass on to the module `kube-prometheus-stack` to activate and then configure `thanos-sidecar`."
  value       = local.metrics_archives
}

output "thanos_enabled" {
  description = "Flag to say that Thanos is enabled. It takes the output that comes from the main module and passes it along to the code that called this variant in the first place."
  value       = module.thanos.thanos_enabled
}
