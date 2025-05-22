
resource "kubernetes_ingress_v1" "prometheus" {
  metadata {
    name      = "prometheus-ingress"
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
          path      = "/prometheus(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "monitoring-kube-prometheus-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}
