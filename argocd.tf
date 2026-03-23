resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = kubernetes_namespace_v1.argocd.metadata[0].name
  create_namespace = false

  wait            = true
  timeout         = 600
  cleanup_on_fail = true

  depends_on = [
    minikube_cluster.cluster,
    kubernetes_namespace_v1.argocd,
  ]
}
