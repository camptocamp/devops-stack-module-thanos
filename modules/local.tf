locals {
  profiles_yaml = [ for i in var.profiles : templatefile("${path.module}/profiles/${i}.yaml", {
      cluster_name   = var.cluster_name,
      cluster_issuer = var.cluster_issuer,
      base_domain    = var.base_domain,
      thanos         = var.thanos,
  }) ]
  all_yaml = concat(local.profiles_yaml, var.extra_yaml)
}
