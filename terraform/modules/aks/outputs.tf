output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "cluster_identity" {
  value = azurerm_kubernetes_cluster.main.identity
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}