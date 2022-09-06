<!-- BEGIN_TF_DOCS -->
### Requirements

No requirements.

### Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

### Modules

The following Modules are called:

#### <a name="module_iam_assumable_role_thanos"></a> [iam\_assumable\_role\_thanos](#module\_iam\_assumable\_role\_thanos)

Source: terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc

Version: 4.0.0

#### <a name="module_thanos"></a> [thanos](#module\_thanos)

Source: ../../

Version:

### Resources

The following resources are used by this module:

- [aws_iam_policy.thanos_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_s3_bucket.thanos_metrics_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) (resource)
- [aws_iam_policy_document.thanos_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) (data source)

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

#### <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url)

Description: value

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

#### <a name="output_metrics_archives"></a> [metrics\_archives](#output\_metrics\_archives)

Description: value

#### <a name="output_thanos_enabled"></a> [thanos\_enabled](#output\_thanos\_enabled)

Description: value
<!-- END_TF_DOCS -->