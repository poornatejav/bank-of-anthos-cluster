terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}


provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  version          = "56.6.2"
  create_namespace = true

  values = [
    yamlencode({
      grafana = {
        ingress = {
          enabled           = true
          ingressClassName  = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/"
          }
          hosts = [{
            host = "*"
            paths = [{
              path     = "/grafana"
              pathType = "Prefix"
            }]
          }]
        }
        service = {
          type = "ClusterIP"
        }
        serve_from_sub_path = true
      }

      prometheus = {
        ingress = {
          enabled           = true
          ingressClassName  = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/"
          }
          hosts = [{
            host = "*"
            paths = [{
              path     = "/prometheus"
              pathType = "Prefix"
            }]
          }]
        }
        service = {
          type = "ClusterIP"
        }
      }

      alertmanager = {
        ingress = {
          enabled           = true
          ingressClassName  = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/"
          }
          hosts = [{
            host = "*"
            paths = [{
              path     = "/alertmanager"
              pathType = "Prefix"
            }]
          }]
        }
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]
}