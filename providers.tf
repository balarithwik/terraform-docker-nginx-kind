terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "kubernetes" {
  # Explicit path to your kubeconfig
  config_path = "C:/Users/Bala/.kube/config"
}