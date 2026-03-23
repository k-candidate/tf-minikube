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

resource "helm_release" "argocd_bootstrap" {
  count = var.gitops_bootstrap_enabled ? 1 : 0

  name             = "argocd-bootstrap"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = var.argocd_apps_chart_version
  namespace        = kubernetes_namespace_v1.argocd.metadata[0].name
  create_namespace = false

  wait            = true
  timeout         = 600
  cleanup_on_fail = true

  values = [
    yamlencode({
      applications = {
        (var.gitops_root_application_name) = {
          namespace = var.argocd_namespace
          project   = "default"
          source = {
            repoURL        = var.gitops_repo_url
            targetRevision = var.gitops_target_revision
            path           = var.gitops_apps_path
            directory = {
              recurse = true
            }
          }
          destination = {
            server    = "https://kubernetes.default.svc"
            namespace = var.argocd_namespace
          }
          syncPolicy = {
            automated = {
              prune    = true
              selfHeal = true
            }
            syncOptions = [
              "CreateNamespace=true",
            ]
          }
        }
      }
    })
  ]

  depends_on = [helm_release.argocd]
}
