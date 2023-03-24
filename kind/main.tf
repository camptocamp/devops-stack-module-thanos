module "thanos" {
  source = "../"

  cluster_name     = var.cluster_name
  base_domain      = var.base_domain
  argocd_namespace = var.argocd_namespace
  target_revision  = var.target_revision
  cluster_issuer   = var.cluster_issuer
  namespace        = var.namespace
  app_autosync     = var.app_autosync
  dependency_ids   = var.dependency_ids

  thanos = var.thanos

  sensitive_values = merge({
    "thanos.objstoreConfig.config.secret_key" = var.metrics_storage.secret_access_key
  }, var.sensitive_values)


  helm_values = concat(local.helm_values, var.helm_values)
}
