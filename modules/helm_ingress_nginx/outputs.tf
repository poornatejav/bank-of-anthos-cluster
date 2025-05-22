
output "nginx_lb_hostname" {
  value = helm_release.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
}
