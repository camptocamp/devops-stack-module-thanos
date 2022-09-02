# devops-stack-module-thanos

A [DevOps Stack](https://devops-stack.io) module to deploy and configure [Thanos](https://thanos.io).

## Usage

### On EKS

This module can be instantiated by adding the following block on your Terraform configuration:

```hcl
module "thanos" {
  source = "git::https://github.com/camptocamp/devops-stack-module-thanos.git//eks"

  cluster_name     = var.cluster_name
  argocd_namespace = module.cluster.argocd_namespace # TODO Make sure we use a generic name for the cluster module instead of using eks or aks, to be discussed
  base_domain      = module.cluster.base_domain
  cluster_issuer   = var.cluster_issuer # TODO Verify that we will create this variable and document it in the main module

  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url

  thanos = {
    oicd = module.oicd.oicd
  }`

  depends_on = [module.argocd_bootstrap]
}
```

## Technical Reference

### Dependencies

#### `module.argocd_bootstrap`

This module must be one of the first ones to be deployed and because of that it only needs this explicit dependency.

### EKS Submodule

<!-- BEGIN_TF_DOCS_EKS -->
<!-- END_TF_DOCS_EKS -->
