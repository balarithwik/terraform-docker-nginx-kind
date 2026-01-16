########################
# NGINX Deployment
########################
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

    strategy {}
  }
}

########################
# NGINX Service
########################
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }

    type = "NodePort"
  }
}

########################
# MYSQL Deployment
########################
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
            value = "root"
          }

          port {
            container_port = 3306
          }
        }
      }
    }

    strategy {}
  }
}

########################
# MYSQL Service
########################
resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.mysql.metadata[0].labels.app
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}
