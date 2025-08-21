resource "kubernetes_namespace" "ingress_nginx" {
  count = var.enable_ingress_nginx ? 1 : 0
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  count      = var.enable_ingress_nginx ? 1 : 0
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx[0].metadata[0].name
  version    = "4.8.3"
}

resource "kubernetes_namespace" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  count      = var.enable_cert_manager ? 1 : 0
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager[0].metadata[0].name
  version    = "v1.13.3"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_namespace" "external_dns" {
  count = var.enable_external_dns ? 1 : 0
  metadata {
    name = "external-dns"
  }
}

resource "helm_release" "external_dns" {
  count      = var.enable_external_dns && var.dns_zone_name != "" ? 1 : 0
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = kubernetes_namespace.external_dns[0].metadata[0].name
  version    = "1.14.3"

  set {
    name  = "provider"
    value = "azure"
  }

  set {
    name  = "azure.resourceGroup"
    value = var.dns_zone_resource_group
  }

  set {
    name  = "domainFilters[0]"
    value = var.dns_zone_name
  }
}