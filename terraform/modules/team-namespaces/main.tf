resource "kubernetes_namespace" "team" {
  for_each = { for team in var.teams : team.name => team }

  metadata {
    name = each.value.namespace
    labels = {
      "team" = each.value.name
    }
  }
}

resource "kubernetes_resource_quota" "team" {
  for_each = { for team in var.teams : team.name => team }

  metadata {
    name      = "${each.value.name}-quota"
    namespace = kubernetes_namespace.team[each.key].metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = "4"
      "requests.memory" = "8Gi"
      "limits.cpu"      = "8"
      "limits.memory"   = "16Gi"
      "pods"            = "10"
      "services"        = "5"
    }
  }
}

resource "kubernetes_role" "team_admin" {
  for_each = { for team in var.teams : team.name => team }

  metadata {
    namespace = kubernetes_namespace.team[each.key].metadata[0].name
    name      = "${each.value.name}-admin"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role" "team_member" {
  for_each = { for team in var.teams : team.name => team }

  metadata {
    namespace = kubernetes_namespace.team[each.key].metadata[0].name
    name      = "${each.value.name}-member"
  }

  rule {
    api_groups = ["", "apps", "extensions"]
    resources  = ["pods", "services", "deployments", "configmaps", "secrets"]
    verbs      = ["get", "list", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding" "team_admin" {
  for_each = { for team in var.teams : team.name => team if length(team.admins) > 0 }

  metadata {
    name      = "${each.value.name}-admin-binding"
    namespace = kubernetes_namespace.team[each.key].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.team_admin[each.key].metadata[0].name
  }

  dynamic "subject" {
    for_each = each.value.admins
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

resource "kubernetes_role_binding" "team_member" {
  for_each = { for team in var.teams : team.name => team if length(team.members) > 0 }

  metadata {
    name      = "${each.value.name}-member-binding"
    namespace = kubernetes_namespace.team[each.key].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.team_member[each.key].metadata[0].name
  }

  dynamic "subject" {
    for_each = each.value.members
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}