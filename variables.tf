#######################
## Standard variables
#######################

variable "cluster_name" {
  description = "Name given to the cluster. This value will be used to generate the URLs in order to create the ingresses to access the application."
  type        = string
}

variable "base_domain" {
  description = "Base domain of the cluster. This value will be used to generate the URLs in order to create the ingresses to access the application."
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace used by Argo CD where the Application and AppProject resources should be created."
  type        = string
}

variable "cluster_issuer" {
  description = "SSL certificate issuer to use. Usually you would configure this value as `letsencrypt-staging` or `letsencrypt-prod` on your root `*.tf` files."
  type        = string
  default     = "ca-issuer"
}

variable "namespace" {
  description = "The namespace where the application's resources will reside (it will be created in case it dows not already exist)."
  type        = string
  default     = "thanos"
}

variable "helm_values" {
  description = "Helm values, passed as a list of HCL structures. These values are concatenated with the default ones and then passed to the application's charts."
  type        = any
  default     = []
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)

  default = {}
}

#######################
## Module variables
#######################

variable "thanos" {
  description = "Most frequently used Thanos settings. This variable is merged with the local value `thanos_defaults`, which contains some sensible defaults. You can check the default values on the link:./local.tf[`local.tf`] file. If there still is anything other that needs to be customized, you can always pass on configuration values using the variable `helm_values`."
  type        = any
  default     = {}
}
