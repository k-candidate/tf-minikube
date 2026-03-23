resource "minikube_cluster" "cluster" {
  driver = var.minikube_driver
  vm     = var.minikube_vm
  cni    = var.minikube_cni
  nodes  = var.minikube_nodes
  cpus   = var.minikube_cpus
  memory = var.minikube_memory

  addons = var.minikube_addons
}
