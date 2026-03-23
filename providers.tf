terraform {
  required_version = ">= 1.8.0"

  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "0.6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}

provider "minikube" {
  kubernetes_version = var.kubernetes_version
}

provider "kubernetes" {
  host                   = minikube_cluster.cluster.host
  client_certificate     = minikube_cluster.cluster.client_certificate
  client_key             = minikube_cluster.cluster.client_key
  cluster_ca_certificate = minikube_cluster.cluster.cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = minikube_cluster.cluster.host
    client_certificate     = minikube_cluster.cluster.client_certificate
    client_key             = minikube_cluster.cluster.client_key
    cluster_ca_certificate = minikube_cluster.cluster.cluster_ca_certificate
  }
}
