variable "kubernetes_version" {
  description = "Kubernetes version Minikube should use."
  type        = string
  default     = "v1.32.0"
}

variable "minikube_driver" {
  description = "Minikube driver to use. On Linux, docker is usually the simplest choice."
  type        = string
  default     = "docker"
}

variable "minikube_vm" {
  description = "Whether Minikube should use a VM-based driver. Keep this false for the docker driver."
  type        = bool
  default     = false
}

variable "minikube_cni" {
  description = "CNI plugin to use for the Minikube cluster."
  type        = string
  default     = "bridge"
}

variable "minikube_nodes" {
  description = "Number of Minikube nodes to create."
  type        = number
  default     = 1
}

variable "minikube_cpus" {
  description = "Number of CPUs to assign to each Minikube node."
  type        = number
  default     = 2
}

variable "minikube_memory" {
  description = "Memory in MB to assign to each Minikube node."
  type        = number
  default     = 4096
}

variable "minikube_addons" {
  description = "Minikube addons to enable when the cluster is created."
  type        = list(string)
  default = [
    "default-storageclass",
    "ingress",
    "storage-provisioner",
  ]
}

variable "argocd_namespace" {
  description = "Namespace where Argo CD will be installed."
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Version of the Argo CD Helm chart to install."
  type        = string
  default     = "9.4.15"
}

variable "argocd_apps_chart_version" {
  description = "Version of the companion argocd-apps Helm chart used for optional GitOps bootstrap."
  type        = string
  default     = "2.0.4"
}

variable "gitops_bootstrap_enabled" {
  description = "Whether Terraform should create the root Argo CD Application that bootstraps the GitOps repo."
  type        = bool
  default     = true
}

variable "gitops_root_application_name" {
  description = "Name of the root Argo CD Application Terraform creates for GitOps bootstrap."
  type        = string
  default     = "minikube-root"
}

variable "gitops_repo_url" {
  description = "Git repository URL Argo CD should watch for GitOps application definitions."
  type        = string
  default     = "https://github.com/k-candidate/gitops-apps.git"
}

variable "gitops_target_revision" {
  description = "Git revision Argo CD should track in the GitOps repo."
  type        = string
  default     = "main"
}

variable "gitops_apps_path" {
  description = "Path in the GitOps repo that contains the environment application definitions."
  type        = string
  default     = "apps/minikube"
}

