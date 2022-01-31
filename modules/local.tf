locals {
  default_yaml = [ templatefile("${path.module}/profiles/values.tmpl.yaml", {
      cluster_name   = var.cluster_name,
      cluster_issuer = var.cluster_issuer,
      base_domain    = var.base_domain,
      thanos         = var.thanos,
  }) ]
  all_yaml = concat(local.default_yaml, var.extra_yaml)
}
