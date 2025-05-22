resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "6.7.12"
  create_namespace = true

  values = [
    yamlencode({
      server = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          annotations = {
            "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
          }
          paths = [{
            path     = "/argocd"
            pathType = "Prefix"
          }]
        }
      }
    })
  ]

  depends_on = [module.eks]
}
