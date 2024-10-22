#######################
## Standard variables
#######################

variable "cluster_name" {
  description = "Name given to the cluster. Value used for the ingress' URL of the application."
  type        = string
}

variable "base_domain" {
  description = "Base domain of the cluster. Value used for the ingress' URL of the application."
  type        = string
}

variable "subdomain" {
  description = "Subdomain of the cluster. Value used for the ingress' URL of the application."
  type        = string
  default     = "apps"
  nullable    = false
}

variable "enable_short_domain" {
  description = "Boolean to enable the usage of the base domain without the cluster name. Disable this when you cannot have a wildcard domain for your domain in the style `*.[subdomain].base_domain.tld`. This way, cert-manager will be able to generate valid certificates for the ingress."
  type        = bool
  default     = true
  nullable    = false
}

variable "argocd_project" {
  description = "Name of the Argo CD AppProject where the Application should be created. If not set, the Application will be created in a new AppProject only for this Application."
  type        = string
  default     = null
}

variable "argocd_labels" {
  description = "Labels to attach to the Argo CD Application resource."
  type        = map(string)
  default     = {}
}

variable "destination_cluster" {
  description = "Destination cluster where the application should be deployed."
  type        = string
  default     = "in-cluster"
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v7.0.0" # x-release-please-version
}

variable "secrets_names" {
  description = "Name of the `ClusterSecretStore` used by the External Secrets Operator and the names of the secrets required for this module."
  type = object({
    cluster_secret_store_name = string
    thanos = object({
      metrics_storage            = string
      oauth2_proxy_cookie_secret = string
      oidc_client_secret         = string
      redis_password             = string
    })
  })
  nullable = false
}

variable "cluster_issuer" {
  description = "SSL certificate issuer to use. Usually you would configure this value as `letsencrypt-staging` or `letsencrypt-prod` on your root `*.tf` files."
  type        = string
  default     = "selfsigned-issuer"
}

variable "helm_values" {
  description = "Helm chart value overrides. They should be passed as a list of HCL structures."
  type        = any
  default     = []
}

variable "deep_merge_append_list" {
  description = "A boolean flag to enable/disable appending lists instead of overwriting them."
  type        = bool
  default     = false
}

variable "app_autosync" {
  description = "Automated sync options for the Argo CD Application resource."
  type = object({
    allow_empty = optional(bool)
    prune       = optional(bool)
    self_heal   = optional(bool)
  })
  default = {
    allow_empty = false
    prune       = true
    self_heal   = true
  }
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)
  default     = {}
}

#######################
## Module variables
#######################

variable "thanos" {
  description = "Most frequently used Thanos settings. This variable is merged with the local value `thanos_defaults`, which contains some sensible defaults. You can check the default values on the link:./local.tf[`local.tf`] file. If there still is anything other that needs to be customized, you can always pass on configuration values using the variable `helm_values`."
  type        = any
  default     = {}
}

variable "resources" {
  description = <<-EOT
    Resource limits and requests for Thanos' components. Follow the style on https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/[official documentation] to understand the format of the values.

    IMPORTANT: These are not production values. You should always adjust them to your needs.
  EOT
  type = object({

    query = optional(object({
      requests = optional(object({
        cpu    = optional(string, "250m")
        memory = optional(string, "512Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "512Mi")
      }), {})
    }), {})

    query_frontend = optional(object({
      requests = optional(object({
        cpu    = optional(string, "250m")
        memory = optional(string, "256Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "512Mi")
      }), {})
    }), {})

    bucketweb = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

    compactor = optional(object({
      requests = optional(object({
        cpu    = optional(string, "250m")
        memory = optional(string, "256Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "512Mi")
      }), {})
    }), {})

    storegateway = optional(object({
      requests = optional(object({
        cpu    = optional(string, "250m")
        memory = optional(string, "512Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "512Mi")
      }), {})
    }), {})

    redis = optional(object({
      requests = optional(object({
        cpu    = optional(string, "200m")
        memory = optional(string, "256Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "512Mi")
      }), {})
    }), {})

  })
  default = {}
}

variable "enable_service_monitor" {
  description = "Boolean to enable the deployment of a service monitor for Prometheus. This also enables the deployment of default Prometheus rules and Grafana dashboards, which are embedded inside the chart templates and are taken from the official Thanos examples, available https://github.com/thanos-io/thanos/blob/main/examples/alerts/alerts.yaml[here]."
  type        = bool
  default     = false
}

variable "oidc" {
  description = "OIDC settings to configure the access to the web interfaces of Thanos."
  type = object({
    issuer_url              = string
    oauth_url               = string
    token_url               = string
    api_url                 = string
    client_id               = string
    oauth2_proxy_extra_args = optional(list(string), [])
  })
  nullable = false
}

variable "compactor_persistence_size" {
  description = <<-EOT
    Size of the PVC for the Thanos Compactor component.

    By default, it is set at 10Gi but the documentation recommends a size of 100-300Gi. We chose this small value for test deployments without much metrics. 
    We strongly recommend setting this value to bigger sizes, otherwise the compactor will NOT work on a production deployment.
  EOT
  type        = string
  default     = "10Gi"
  nullable    = false
}
