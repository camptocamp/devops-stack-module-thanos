module "thanos" {
  source = "../"

  cluster_name           = var.cluster_name
  base_domain            = var.base_domain
  subdomain              = var.subdomain
  enable_short_domain    = var.enable_short_domain
  argocd_project         = var.argocd_project
  argocd_labels          = var.argocd_labels
  destination_cluster    = var.destination_cluster
  target_revision        = var.target_revision
  secrets_names          = var.secrets_names
  cluster_issuer         = var.cluster_issuer
  deep_merge_append_list = var.deep_merge_append_list
  app_autosync           = var.app_autosync
  dependency_ids         = var.dependency_ids

  resources                  = var.resources
  enable_service_monitor     = var.enable_service_monitor
  oidc                       = var.oidc
  compactor_persistence_size = var.compactor_persistence_size

  thanos = var.thanos

  helm_values = concat(local.helm_values, var.helm_values)
}
