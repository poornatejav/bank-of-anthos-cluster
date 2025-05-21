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
          enabled = true
          ingressClassName = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
          }
          hosts = ["*"]
          paths = [{
            path     = "/grafana(/|$)(.*)"
            pathType = "ImplementationSpecific"
          }]
        }
        service = {
          type = "ClusterIP"
        }
      },
      prometheus = {
        ingress = {
          enabled = true
          ingressClassName = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
          }
          hosts = ["*"]
          paths = [{
            path     = "/prometheus(/|$)(.*)"
            pathType = "ImplementationSpecific"
          }]
        }
        service = {
          type = "ClusterIP"
        }
      },
      alertmanager = {
        ingress = {
          enabled = true
          ingressClassName = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
          }
          hosts = ["*"]
          paths = [{
            path     = "/alertmanager(/|$)(.*)"
            pathType = "ImplementationSpecific"
          }]
        }
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]
}
