# Optional Dynatrace OneAgent deployment
# Uncomment and configure when ready for enterprise monitoring

# resource "kubernetes_namespace" "dynatrace" {
#   count = var.enable_dynatrace ? 1 : 0
#   metadata {
#     name = "dynatrace"
#   }
# }

# resource "helm_release" "dynatrace" {
#   count      = var.enable_dynatrace ? 1 : 0
#   name       = "dynatrace-oneagent"
#   repository = "https://raw.githubusercontent.com/Dynatrace/helm-charts/master/repos/stable"
#   chart      = "dynatrace-oneagent-operator"
#   namespace  = kubernetes_namespace.dynatrace[0].metadata[0].name
#   version    = "0.10.1"

#   set_sensitive {
#     name  = "oneagent.apiToken"
#     value = var.dynatrace_api_token
#   }

#   set_sensitive {
#     name  = "oneagent.paasToken"
#     value = var.dynatrace_paas_token
#   }

#   set {
#     name  = "oneagent.apiUrl"
#     value = var.dynatrace_api_url
#   }
# }