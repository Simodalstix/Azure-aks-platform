#!/bin/bash
set -e

echo "Deploying AKS GitOps Platform..."

# Initialize Terraform
cd terraform
terraform init

# Plan deployment
terraform plan -var-file="terraform.tfvars"

# Apply deployment
terraform apply -var-file="terraform.tfvars" -auto-approve

echo "Getting AKS credentials..."
CLUSTER_NAME=$(terraform output -raw cluster_name)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)

az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

echo "Deployment complete!"
echo "Access ArgoCD UI: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "ArgoCD admin password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"