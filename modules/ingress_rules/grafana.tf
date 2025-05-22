
resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana-ingress"
    namespace = "monitoring"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
      "nginx.ingress.kubernetes.io/use-regex"      = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path      = "/grafana(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "monitoring-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
