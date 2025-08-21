resource "kubernetes_namespace" "argocd" {
  count = var.gitops_tool == "argocd" ? 1 : 0
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  count      = var.gitops_tool == "argocd" ? 1 : 0
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd[0].metadata[0].name
  version    = "5.51.6"

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]
}

resource "kubernetes_namespace" "flux_system" {
  count = var.gitops_tool == "flux" ? 1 : 0
  metadata {
    name = "flux-system"
  }
}

resource "helm_release" "flux" {
  count      = var.gitops_tool == "flux" ? 1 : 0
  name       = "flux2"
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2"
  namespace  = kubernetes_namespace.flux_system[0].metadata[0].name
  version    = "2.12.1"
}