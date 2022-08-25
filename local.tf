locals {
  helm_values = [{
    thanos = {

      storegateway = {
        enabled = true
        persistence = {
          enabled = false
        }
        resources = {
          limits = {
            memory = "2Gi"
          }
          requests = {
            cpu    = "0.5"
            memory = "1Gi"
          }
        }
      }

      query = {
        # We disabled the direct connection to the sidecar so thano-query
        # depends on thanos-storegateway to obtain the metrics directly from
        # the S3 bucket. Note that storegateway gets new blocks from the bucket
        # every 30 mins.
        dnsDiscovery = {
          enabled = false
        }
        stores = [
          "thanos-storegateway:10901"
        ]
        resources = {
          limits = {
            memory = "1Gi"
          }
          requests = {
            cpu    = "0.5"
            memory = "512Mi"
          }
        }
      }

      compactor = {
        enabled = true
        retentionResolutionRaw = "${local.thanos.compactor_retention.raw}"
        retentionResolution5m  = "${local.thanos.compactor_retention.five_min}"
        retentionResolution1h  = "${local.thanos.compactor_retention.one_hour}"
        resources = {
          limits = {
            memory = "1Gi"
          }
          requests = {
            cpu    = "0.5"
            memory = "512Mi"
          }
        }
        persistence = {
          # We had the access mode set as ReadWriteMany, but it was not 
          # supported with AWS gp2 EBS volumes. Since the compactor is the only
          # pod accessing this volume, there should be no issue to have this as
          # ReadWriteOnce (https://stackoverflow.com/a/57799347).
          accessModes = [
            "ReadWriteOnce"
          ]
        }
      }

      bucketweb = {
        enabled = "true"
        sidecars = [{
          args = concat([
            "--http-address=0.0.0.0:9075",
            "--upstream=http://localhost:8080",
            "--provider=oidc",
            "--oidc-issuer-url=${replace(local.thanos.oidc.issuer_url, "\"", "\\\"")}",
            "--client-id=${replace(local.thanos.oidc.client_id, "\"", "\\\"")}",
            "--client-secret=${replace(local.thanos.oidc.client_secret, "\"", "\\\"")}",
            "--cookie-secure=false",
            "--cookie-secret=${replace(random_password.oauth2_cookie_secret.result, "\"", "\\\"")}",
            "--email-domain=*",
            "--redirect-url=https://${local.thanos.bucketweb_domain}/oauth2/callback",
          ], local.thanos.oidc.oauth2_proxy_extra_args)
          image = "quay.io/oauth2-proxy/oauth2-proxy:v7.1.3"
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
          enabled = "true"
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-withclustername@kubernetescrd"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          tls      = false
          hostname = ""
          extraRules = [
            {
              host = "thanos-bucketweb.apps.${var.base_domain}"
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
            },
            {
              host = "${local.thanos.bucketweb_domain}"
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
            },
          ]
          extraTls = [{
            secretName = "thanos-bucketweb-tls"
            hosts = [
              "thanos-bucketweb.apps.${var.base_domain}",
              "${local.thanos.bucketweb_domain}"
            ]
          }]
        }
      }

      queryFrontend = {
        sidecars = [{
          args = concat([
            "--http-address=0.0.0.0:9075",
            "--upstream=http://localhost:10902",
            "--provider=oidc",
            "--oidc-issuer-url=${replace(local.thanos.oidc.issuer_url, "\"", "\\\"")}",
            "--client-id=${replace(local.thanos.oidc.client_id, "\"", "\\\"")}",
            "--client-secret=${replace(local.thanos.oidc.client_secret, "\"", "\\\"")}",
            "--cookie-secure=false",
            "--cookie-secret=${replace(random_password.oauth2_cookie_secret.result, "\"", "\\\"")}",
            "--email-domain=*",
            "--redirect-url=https://${local.thanos.query_domain}/oauth2/callback",
          ], local.thanos.oidc.oauth2_proxy_extra_args)
          image = "quay.io/oauth2-proxy/oauth2-proxy:v7.1.3"
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
          enabled = "true"
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-withclustername@kubernetescrd"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          tls      = false
          hostname = ""
          extraRules = [
            {
              host = "thanos-query.apps.${var.base_domain}"
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
            },
            {
              host = "${local.thanos.query_domain}"
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
            },
          ]
          extraTls = [{
            secretName = "thanos-query-tls"
            hosts = [
              "thanos-query.apps.${var.base_domain}",
              "${local.thanos.query_domain}"
            ]
          }]
        }
      }

    }
  }]

  thanos_defaults = {
    query_domain     = "thanos-query.apps.${var.cluster_name}.${var.base_domain}"
    bucketweb_domain = "thanos-bucketweb.apps.${var.cluster_name}.${var.base_domain}"
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
