
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.10.0"

  create_namespace = true

  values = [
    yamlencode({
      controller = {
        ingressClass = "nginx"
        ingressClassResource = {
          name    = "nginx"
          enabled = true
          default = true
        }
        service = {
          type = "LoadBalancer"
        }
        watchIngressWithoutClass = true
        scope = {
          enabled = false
        }
      }
    })
  ]
}
