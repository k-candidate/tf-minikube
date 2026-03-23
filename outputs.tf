output "minikube_profile" {
  description = "Minikube profile name managed by Terraform."
  value       = minikube_cluster.cluster.cluster_name
}

output "minikube_host" {
  description = "Kubernetes API server host for the Minikube cluster."
  value       = minikube_cluster.cluster.host
}

output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "argocd_release_name" {
  description = "Helm release name for Argo CD."
  value       = helm_release.argocd.name
}

output "argocd_initial_admin_secret_name" {
  description = "Secret that stores the initial Argo CD admin password."
  value       = "argocd-initial-admin-secret"
}
