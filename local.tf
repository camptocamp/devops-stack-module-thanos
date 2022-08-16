locals {
  helm_values = [{
    thanos = {

      storegateway = {
        enabled         = true
        createConfigMap = "true"
      }

      query = {
        dnsDiscovery = {
          sidecarsService   = "kube-prometheus-stack-thanos-discovery"
          sidecarsNamespace = "kube-prometheus-stack"
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
