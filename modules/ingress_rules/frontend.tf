
resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name      = "frontend-ingress"
    namespace = "default"
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
          path      = "/frontend(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "frontend"
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
