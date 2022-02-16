module "thanos" {
  source = "../"

  cluster_name     = var.cluster_name
  cluster_issuer   = var.cluster_issuer
  base_domain      = var.base_domain
  argocd_namespace = var.argocd_namespace

  namespace = var.namespace
  profiles  = var.profiles

  thanos = {
    bucket_config = {
      "type" = "S3",
      "config" = {
        "bucket"     = "thanos",
        "endpoint"   = "minio.minio.svc:9000",
        "insecure"   = true,
        "access_key" = var.minio.access_key,
        "secret_key" = var.minio.secret_key
      }
    }
    bucketweb_domain = "thanos-bucketweb.${var.cluster_name}.${var.base_domain}"
    query_domain     = "thanos-query.${var.cluster_name}.${var.base_domain}"
  }

  #extra_yaml = [ templatefile("${path.module}/values.yaml", {
  #}) ]
}
