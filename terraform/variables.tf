variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
}

variable "enable_aad_integration" {
  description = "Enable Azure AD integration"
  type        = bool
  default     = true
}

variable "enable_workload_identity" {
  description = "Enable workload identity"
  type        = bool
  default     = true
}

variable "enable_key_vault_csi" {
  description = "Enable Key Vault CSI driver"
  type        = bool
  default     = true
}

variable "gitops_tool" {
  description = "GitOps tool to use (argocd or flux)"
  type        = string
  default     = "argocd"
  validation {
    condition     = contains(["argocd", "flux"], var.gitops_tool)
    error_message = "GitOps tool must be either 'argocd' or 'flux'."
  }
}

variable "git_repo_url" {
  description = "Git repository URL for GitOps"
  type        = string
}

variable "enable_ingress_nginx" {
  description = "Enable NGINX ingress controller"
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Enable cert-manager"
  type        = bool
  default     = true
}

variable "enable_external_dns" {
  description = "Enable external-dns"
  type        = bool
  default     = true
}

variable "dns_zone_name" {
  description = "DNS zone name for external-dns"
  type        = string
  default     = ""
}

variable "dns_zone_resource_group" {
  description = "Resource group containing the DNS zone"
  type        = string
  default     = ""
}

variable "teams" {
  description = "List of teams with their configurations"
  type = list(object({
    name      = string
    namespace = string
    admins    = list(string)
    members   = list(string)
  }))
  default = []
}