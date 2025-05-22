output "nginx_lb_hostname" {
  value       = module.ingress_nginx.nginx_lb_hostname
  description = "External Load Balancer DNS"
}
