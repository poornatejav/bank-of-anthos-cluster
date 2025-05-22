resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.10.1"
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        ingressClass = "nginx"
      }
    })
  ]
}
