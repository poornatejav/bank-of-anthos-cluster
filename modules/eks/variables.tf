variable "env" {}
variable "subnet_ids" { type = list(string) }
variable "cluster_role_arn" {}
variable "cluster_role_attachment" {}
variable "node_role_arn" {}