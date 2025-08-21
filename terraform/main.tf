terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.aks.kube_config.0.host
  client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
  client_key            = base64decode(module.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.kube_config.0.host
    client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
    client_key            = base64decode(module.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
  }
}

module "aks" {
  source = "./modules/aks"
  
  resource_group_name = var.resource_group_name
  location           = var.location
  cluster_name       = var.cluster_name
  dns_prefix         = var.dns_prefix
  
  enable_aad_integration = var.enable_aad_integration
  enable_workload_identity = var.enable_workload_identity
  enable_key_vault_csi = var.enable_key_vault_csi
}

module "gitops" {
  source = "./modules/gitops"
  depends_on = [module.aks]
  
  gitops_tool = var.gitops_tool
  git_repo_url = var.git_repo_url
}

module "platform_services" {
  source = "./modules/platform-services"
  depends_on = [module.aks]
  
  enable_ingress_nginx = var.enable_ingress_nginx
  enable_cert_manager = var.enable_cert_manager
  enable_external_dns = var.enable_external_dns
  dns_zone_name = var.dns_zone_name
  dns_zone_resource_group = var.dns_zone_resource_group
}

module "team_namespaces" {
  source = "./modules/team-namespaces"
  depends_on = [module.aks]
  
  teams = var.teams
}