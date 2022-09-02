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

<!-- BEGIN_TF_DOCS -->
### Requirements

No requirements.

### Providers

The following providers are used by this module:

- <a name="provider_argocd"></a> [argocd](#provider\_argocd)

- <a name="provider_null"></a> [null](#provider\_null)

- <a name="provider_random"></a> [random](#provider\_random)

- <a name="provider_utils"></a> [utils](#provider\_utils)

### Modules

No modules.

### Resources

The following resources are used by this module:

- [argocd_application.this](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application) (resource)
- [argocd_project.this](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/project) (resource)
- [null_resource.dependencies](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [random_password.oauth2_cookie_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [utils_deep_merge_yaml.values](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_yaml) (data source)

### Required Inputs

The following input variables are required:

#### <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace)

Description: n/a

Type: `string`

#### <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain)

Description: n/a

Type: `string`

#### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: n/a

Type: `string`

### Optional Inputs

The following input variables are optional (have default values):

#### <a name="input_cluster_issuer"></a> [cluster\_issuer](#input\_cluster\_issuer)

Description: n/a

Type: `string`

Default: `"ca-issuer"`

#### <a name="input_dependency_ids"></a> [dependency\_ids](#input\_dependency\_ids)

Description: n/a

Type: `map(string)`

Default: `{}`

#### <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values)

Description: Helm values, passed as a list of HCL structures.

Type: `any`

Default: `[]`

#### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: n/a

Type: `string`

Default: `"thanos"`

#### <a name="input_thanos"></a> [thanos](#input\_thanos)

Description: Thanos settings

Type: `any`

Default: `{}`

### Outputs

The following outputs are exported:

#### <a name="output_id"></a> [id](#output\_id)

Description: n/a

#### <a name="output_thanos_enabled"></a> [thanos\_enabled](#output\_thanos\_enabled)

Description: n/a
<!-- END_TF_DOCS -->
