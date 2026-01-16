###########################
# Kubernetes Deployment for Nginx
###########################
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

###########################
# Kubernetes Service for Nginx
###########################
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata[0].labels.app
    }

    type = "NodePort"

    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }
  }
}

###########################
# Kubernetes Deployment for MySQL
###########################
resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "rootpassword"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "testdb"
          }

          port {
            container_port = 3306
          }
        }
      }
    }
  }
}

###########################
# Kubernetes Service for MySQL
###########################
resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.mysql.metadata[0].labels.app
    }

    type = "ClusterIP"

    port {
      port        = 3306
      target_port = 3306
    }
  }
}

###########################
# Outputs
###########################
output "nginx_node_port" {
  value = kubernetes_service.nginx.spec[0].node_port
}

output "mysql_service_cluster_ip" {
  value = kubernetes_service.mysql.spec[0].cluster_ip
}
