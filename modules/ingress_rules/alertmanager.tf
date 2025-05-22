
resource "kubernetes_ingress_v1" "alertmanager" {
  metadata {
    name      = "alertmanager-ingress"
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
          path      = "/alertmanager(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "monitoring-kube-prometheus-alertmanager"
              port {
                number = 9093
              }
            }
          }
        }
      }
    }
  }
}
