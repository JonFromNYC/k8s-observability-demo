#!/bin/bash

set -e

NAMESPACE="monitoring"

echo "🔍 Checking if namespace '$NAMESPACE' exists..."
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || {
  echo "📦 Creating namespace '$NAMESPACE'..."
  kubectl create namespace $NAMESPACE
}

echo "📦 Adding Helm repos..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update

echo "🚀 Installing or upgrading Prometheus stack..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE \
  -f helm/prometheus/values.yaml

# Optional Grafana standalone install (only if you want to manage Grafana separately)
# echo "🚀 Installing or upgrading Grafana..."
# helm upgrade --install grafana grafana/grafana \
#   --namespace $NAMESPACE \
#   -f helm/grafana/values.yaml

echo "✅ Done! Monitor with: kubectl get all -n $NAMESPACE"
