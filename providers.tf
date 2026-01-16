terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }

  required_version = ">= 1.5.0"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "docker" {}
