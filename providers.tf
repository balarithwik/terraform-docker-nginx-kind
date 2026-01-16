terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }

  required_version = ">= 1.6.6"
}

provider "kubernetes" {
  config_path = "~/.kube/config" # for local kind cluster
}

provider "docker" {}
