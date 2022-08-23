locals {
  helm_values = [{
    thanos = {

      storegateway = {
        enabled         = true
        persistence = {
          enabled = false
        }
        resources = {
          limits = {
            memory = "2Gi"
          }
          requests = {
            cpu = "0.5"
            memory = "1Gi"
          }
        }
      }

      query = {
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
            cpu = "0.5"
            memory = "512Mi"
          }
        }
      }

      compactor = {
        enabled = true
        # TODO Maybe provide an interface to customize this variables on the module call
        retentionResolutionRaw = "60d"
        retentionResolution5m = "120d"
        retentionResolution1h = "240d"
        resources = {
          limits = {
            memory = "1Gi"
          }
          requests = {
            cpu = "0.5"
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
        ingress = {
          enabled = "true"
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          hostname = "thanos-bucketweb.apps.${var.base_domain}"
          extraHosts = [{
            name = "thanos-bucketweb.apps.${var.cluster_name}.${var.base_domain}"
          }]
          tls = "true"
          extraTls = [{
            secretName = "thanos-bucketweb-tls"
            hosts = [
              "thanos-bucketweb.apps.${var.cluster_name}.${var.base_domain}",
              "thanos-bucketweb.apps.${var.base_domain}"
            ]
          }]
        }
      }

      queryFrontend = {
        ingress = {
          enabled = "true"
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          hostname = "thanos-query.apps.${var.base_domain}"
          extraHosts = [{
            name = "thanos-query.apps.${var.cluster_name}.${var.base_domain}"
          }]
          tls = "true"
          extraTls = [{
            secretName = "thanos-query-tls"
            hosts = [
              "thanos-query.apps.${var.cluster_name}.${var.base_domain}",
              "thanos-query.apps.${var.base_domain}"
            ]
          }]
        }
      }

    }
  }]
}
