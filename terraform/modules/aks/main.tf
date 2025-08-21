resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_D2s_v3"
    type       = "SystemNodePool"
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_aad_integration ? [1] : []
    content {
      managed = true
    }
  }

  dynamic "workload_identity_enabled" {
    for_each = var.enable_workload_identity ? [1] : []
    content {
      workload_identity_enabled = true
    }
  }

  dynamic "oidc_issuer_enabled" {
    for_each = var.enable_workload_identity ? [1] : []
    content {
      oidc_issuer_enabled = true
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.enable_key_vault_csi ? [1] : []
    content {
      secret_rotation_enabled = true
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  name                  = "workload"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size              = "Standard_D4s_v3"
  node_count           = 1
  min_count            = 1
  max_count            = 10
  enable_auto_scaling  = true

  node_labels = {
    "nodepool-type" = "workload"
  }
}