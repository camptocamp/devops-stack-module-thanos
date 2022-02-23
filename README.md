# devops-stack-module-thanos

A [DevOps Stack](https://devops-stack.io) module to deploy and configure [Thanos](https://thanos.io).


## Usage

```hcl
module "metrics-archives" {
  source = "git::https://github.com/camptocamp/devops-stack-module-thanos.git/"

  cluster_name     = var.cluster_name
  argocd_namespace = module.cluster.argocd_namespace
  base_domain      = module.cluster.base_domain
  cluster_issuer   = "ca-issuer"

  minio = {
    access_key = module.storage.access_key
    secret_key = module.storage.secret_key
  }

  depends_on = [ module.monitoring, module.loki-stack ]
}
```
