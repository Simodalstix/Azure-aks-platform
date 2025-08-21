variable "gitops_tool" {
  description = "GitOps tool to use (argocd or flux)"
  type        = string
  default     = "argocd"
}

variable "git_repo_url" {
  description = "Git repository URL for GitOps"
  type        = string
}