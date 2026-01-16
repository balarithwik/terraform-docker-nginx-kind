// outputs.tf
// This file defines the outputs for the Terraform deployment

output "nginx_node_port" {
  description = "NodePort of the Nginx service"
  value       = kubernetes_service.nginx.spec[0].ports[0].node_port
}

output "mysql_service_cluster_ip" {
  description = "ClusterIP of the MySQL service"
  value       = kubernetes_service.mysql.spec[0].cluster_ip
}
