# nginx deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
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

# nginx service
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"  # updated to direct label reference
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30080  # optional fixed NodePort
    }

    type = "NodePort"
  }

}

################################
# MYSQL DEPLOYMENT (ADDED)
################################
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
            value = "appdb"
          }

          port {
            container_port = 3306
          }
        }
      }
    }
  }
}

################################
# MYSQL SERVICE (ADDED)
################################
resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql-service"
  }

  spec {
    selector = {
      app = "mysql"
    }

    type = "ClusterIP"

    port {
      port        = 3306
      target_port = 3306
    }
  }
}
