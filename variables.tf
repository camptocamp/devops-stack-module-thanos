#######################
## Standard variables
#######################

variable "cluster_name" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "cluster_issuer" {
  type    = string
  default = "ca-issuer"
}

variable "namespace" {
  type    = string
  default = "thanos"
}

variable "extra_yaml" {
  type    = list(string)
  default = []
}

#######################
## Module variables
#######################

variable "thanos" {
  type    = any
  default = {}
}
