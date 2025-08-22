# Azure AKS GitOps Platform

A modular, enterprise-ready Kubernetes platform built on Azure AKS, with GitOps delivery, secure defaults, and developer enablement.

## Architecture

- **AKS Cluster**: System + workload node pools with AAD integration
- **GitOps**: ArgoCD or Flux for continuous delivery
- **Platform Services**: NGINX Ingress, Cert Manager, External DNS
- **Security**: Workload Identity, Key Vault CSI, namespace isolation
- **Team Onboarding**: Automated namespace creation with RBAC

## Quick Start

1. Copy and customize configuration:
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

2. Deploy the platform:
```bash
./scripts/deploy.sh
```

3. Access ArgoCD UI:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Configuration

Key variables in `terraform.tfvars`:

- `cluster_name`: AKS cluster name
- `gitops_tool`: "argocd" or "flux"
- `teams`: Team configurations with RBAC
- `dns_zone_name`: For external DNS integration

## Team Onboarding

Add teams to the `teams` variable:

```hcl
teams = [
  {
    name      = "frontend"
    namespace = "frontend"
    admins    = ["user1@company.com"]
    members   = ["user2@company.com"]
  }
]
```

## GitOps Structure

- `gitops/argocd/applications/`: ArgoCD application definitions
- `gitops/manifests/`: Kubernetes manifests per team
- Team repositories should contain their own manifests

## Security Features

- Azure AD integration with RBAC
- Workload Identity for pod authentication
- Key Vault CSI driver for secrets
- Resource quotas per namespace
- Network policies (optional)

## Platform Services

- **Ingress**: NGINX with LoadBalancer
- **TLS**: Cert Manager with Let's Encrypt
- **DNS**: External DNS with Azure DNS
- **Monitoring**: Azure Monitor for containers
- **Autoscaling**: KEDA and HPA support