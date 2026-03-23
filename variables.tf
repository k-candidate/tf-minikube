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
