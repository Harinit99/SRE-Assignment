#!/bin/bash
set -e

# Create KIND cluster
kind create cluster --name metrics-cluster

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD server to be ready
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Port forward ArgoCD
echo "Run 'kubectl port-forward svc/argocd-server -n argocd 8080:443' to access ArgoCD UI"

# Apply ArgoCD App
kubectl apply -f argocd/app.yaml
