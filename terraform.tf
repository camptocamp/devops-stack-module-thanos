terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 4"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3"
    }
  }
}
