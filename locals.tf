locals {
  oauth2_proxy_image = "quay.io/oauth2-proxy/oauth2-proxy:v7.6.0"

  domain      = trimprefix("${var.subdomain}.${var.base_domain}", ".")
  domain_full = trimprefix("${var.subdomain}.${var.cluster_name}.${var.base_domain}", ".")

  ingress_annotations = {
    "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
    "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
    "traefik.ingress.kubernetes.io/router.tls"         = "true"
  }

  helm_values = [{
    secrets_names = {
      cluster_secret_store = var.secrets_names.cluster_secret_store_name
      thanos               = var.secrets_names.thanos
    }

    redis = {
      architecture = "standalone"
      auth = {
        enabled  = true
        password = random_password.redis_password.result
      }
      master = {
        persistence = {
          enabled = false
        }
        resources = {
          requests = { for k, v in var.resources.redis.requests : k => v if v != null }
          limits   = { for k, v in var.resources.redis.limits : k => v if v != null }
        }
      }
    }
    thanos = {
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = var.enable_service_monitor
        }
      }

      storegateway = {
        enabled = true
        persistence = {
          enabled = false
        }
        resources = {
          requests = { for k, v in var.resources.storegateway.requests : k => v if v != null }
          limits   = { for k, v in var.resources.storegateway.limits : k => v if v != null }
        }
        networkPolicy = {
          enabled = false
        }
        extraFlags = [
          # Store Gateway index cache config -> https://thanos.io/tip/components/store.md/#index-cache
          <<-EOT
          --index-cache.config="config":
            addr: "thanos-redis-master:6379"
            password: ${random_password.redis_password.result}
            db: 0
            dial_timeout: 5s
            read_timeout: 3s
            write_timeout: 3s
            max_get_multi_concurrency: 1000
            get_multi_batch_size: 100
            max_set_multi_concurrency: 1000
            set_multi_batch_size: 100
            tls_enabled: false
            cache_size: 0
            max_async_buffer_size: 1000000
            max_async_concurrency: 200
            expiration: 2h
          "type": "REDIS"
          EOT
        ]
      }

      query = {
        dnsDiscovery = {
          enabled           = true
          sidecarsService   = "kube-prometheus-stack-thanos-discovery" # Name of the service that exposes thanos-sidecar
          sidecarsNamespace = "kube-prometheus-stack"
        }
        stores = [
          "thanos-storegateway:10901"
        ]
        resources = {
          requests = { for k, v in var.resources.query.requests : k => v if v != null }
          limits   = { for k, v in var.resources.query.limits : k => v if v != null }
        }
        networkPolicy = {
          enabled = false
        }
      }

      compactor = {
        enabled                = true
        retentionResolutionRaw = "${local.thanos.compactor_retention.raw}"
        retentionResolution5m  = "${local.thanos.compactor_retention.five_min}"
        retentionResolution1h  = "${local.thanos.compactor_retention.one_hour}"
        resources = {
          requests = { for k, v in var.resources.compactor.requests : k => v if v != null }
          limits   = { for k, v in var.resources.compactor.limits : k => v if v != null }
        }
        persistence = {
          # The Access Mode needs to be set as ReadWriteOnce because AWS Elastic Block storage does not support other
          # modes (https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes).
          # Since the compactor is the only pod accessing this volume, there should be no issue to have this as
          # ReadWriteOnce (https://stackoverflow.com/a/57799347).
          accessModes = [
            "ReadWriteOnce"
          ]
          size = var.compactor_persistence_size
        }
        networkPolicy = {
          enabled = false
        }
      }

      bucketweb = {
        enabled = true
        resources = {
          requests = { for k, v in var.resources.bucketweb.requests : k => v if v != null }
          limits   = { for k, v in var.resources.bucketweb.limits : k => v if v != null }
        }
        sidecars = [{
          args = concat([
            "--http-address=0.0.0.0:9075",
            "--upstream=http://localhost:8080",
            "--provider=oidc",
            "--oidc-issuer-url=${replace(var.oidc.issuer_url, "\"", "\\\"")}",
            "--client-id=${replace(var.oidc.client_id, "\"", "\\\"")}",
            "--cookie-secure=false",
            "--email-domain=*",
            "--redirect-url=https://thanos-bucketweb.${local.domain_full}/oauth2/callback",
          ], var.oidc.oauth2_proxy_extra_args)
          env = [
            {
              name = "OAUTH2_PROXY_CLIENT_SECRET"
              valueFrom = {
                secretKeyRef = {
                  name = "thanos-oidc-client-secret"
                  key  = "value"
                }
              }
            },
            {
              name = "OAUTH2_PROXY_COOKIE_SECRET"
              valueFrom = {
                secretKeyRef = {
                  name = "thanos-oauth2-proxy-cookie-secret"
                  key  = "value"
                }
              }
            }
          ]
          image = local.oauth2_proxy_image
          name  = "thanos-proxy"
          ports = [{
            containerPort = 9075
            name          = "proxy"
          }]
        }]
        service = {
          extraPorts = [{
            name       = "proxy"
            port       = 9075
            protocol   = "TCP"
            targetPort = "proxy"
          }]
        }
        ingress = {
          enabled     = true
          annotations = local.ingress_annotations
          tls         = false
          hostname    = ""

          extraRules = [for domain in [
            "thanos-bucketweb.${local.domain_full}",
            var.enable_short_domain ? "thanos-bucketweb.${local.domain}" : null,
            ] : {
            host = "${domain}"
            http = {
              paths = [
                {
                  backend = {
                    service = {
                      name = "thanos-bucketweb"
                      port = {
                        name = "proxy"
                      }
                    }
                  }
                  path     = "/"
                  pathType = "ImplementationSpecific"
                }
              ]
            }
          }]
          extraTls = [{
            secretName = "thanos-bucketweb-tls"
            hosts = compact([
              "thanos-bucketweb.${local.domain_full}",
              var.enable_short_domain ? "thanos-bucketweb.${local.domain}" : null,
            ])
          }]
        }
        networkPolicy = {
          enabled = false
        }
      }

      queryFrontend = {
        resources = {
          requests = { for k, v in var.resources.query_frontend.requests : k => v if v != null }
          limits   = { for k, v in var.resources.query_frontend.limits : k => v if v != null }
        }
        extraFlags = [
          # Query Frontend response cache config -> https://thanos.io/tip/components/query-frontend.md/#caching
          <<-EOT
          --query-range.response-cache-config="config":
            addr: "thanos-redis-master:6379"
            password: ${random_password.redis_password.result}
            db: 1
            dial_timeout: 5s
            read_timeout: 3s
            write_timeout: 3s
            max_get_multi_concurrency: 1000
            get_multi_batch_size: 100
            max_set_multi_concurrency: 1000
            set_multi_batch_size: 100
            tls_enabled: false
            cache_size: 0
            max_async_buffer_size: 1000000
            max_async_concurrency: 200
            expiration: 2h
          "type": "REDIS"   
          EOT
          ,
          <<-EOT
          --labels.response-cache-config="config":
            addr: "thanos-redis-master:6379"
            password: ${random_password.redis_password.result}
            db: 2
            dial_timeout: 5s
            read_timeout: 3s
            write_timeout: 3s
            max_get_multi_concurrency: 1000
            get_multi_batch_size: 100
            max_set_multi_concurrency: 1000
            set_multi_batch_size: 100
            tls_enabled: false
            cache_size: 0
            max_async_buffer_size: 1000000
            max_async_concurrency: 200
            expiration: 2h
          "type": "REDIS"   
          EOT
          ,
        ]
        sidecars = [{
          args = concat([
            "--http-address=0.0.0.0:9075",
            "--upstream=http://localhost:9090",
            "--provider=oidc",
            "--oidc-issuer-url=${replace(var.oidc.issuer_url, "\"", "\\\"")}",
            "--client-id=${replace(var.oidc.client_id, "\"", "\\\"")}",
            "--cookie-secure=false",
            "--email-domain=*",
            "--redirect-url=https://thanos-query.${local.domain_full}/oauth2/callback",
          ], var.oidc.oauth2_proxy_extra_args)
          env = [
            {
              name = "OAUTH2_PROXY_CLIENT_SECRET"
              valueFrom = {
                secretKeyRef = {
                  name = "thanos-oidc-client-secret"
                  key  = "value"
                }
              }
            },
            {
              name = "OAUTH2_PROXY_COOKIE_SECRET"
              valueFrom = {
                secretKeyRef = {
                  name = "thanos-oauth2-proxy-cookie-secret"
                  key  = "value"
                }
              }
            }
          ]
          image = local.oauth2_proxy_image
          name  = "thanos-proxy"
          ports = [{
            containerPort = 9075
            name          = "proxy"
          }]
        }]
        service = {
          extraPorts = [{
            name       = "proxy"
            port       = 9075
            protocol   = "TCP"
            targetPort = "proxy"
          }]
        }
        ingress = {
          enabled     = true
          annotations = local.ingress_annotations
          tls         = false
          hostname    = ""
          extraRules = [for domain in compact([
            "thanos-query.${local.domain_full}",
            var.enable_short_domain ? "thanos-query.${local.domain}" : null,
            ]) : {
            host = "${domain}"
            http = {
              paths = [
                {
                  backend = {
                    service = {
                      name = "thanos-query-frontend"
                      port = {
                        name = "proxy"
                      }
                    }
                  }
                  path     = "/"
                  pathType = "ImplementationSpecific"
                }
              ]
            }
          }]
          extraTls = [{
            secretName = "thanos-query-tls"
            hosts = compact([
              "thanos-query.${local.domain_full}",
              var.enable_short_domain ? "thanos-query.${local.domain}" : null,
            ])
          }]
        }
        networkPolicy = {
          enabled = false
        }
      }
      receive = {
        networkPolicy = {
          enabled = false
        }
      }
      ruler = {
        networkPolicy = {
          enabled = false
        }
      }
    }
  }]

  thanos_defaults = {
    # TODO Create proper Terraform variables for these values instead of bundling everything inside of these locals

    compactor_retention = {
      raw      = "60d"
      five_min = "120d"
      one_hour = "240d"
    }
  }

  thanos = merge(
    local.thanos_defaults,
    var.thanos,
  )
}
