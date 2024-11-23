#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Catch errors in pipelines

NAMESPACE="mlflow"

log() {
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") - $1"
}

# Create Namespace
log "Creating namespace..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NAMESPACE
EOF
log "Namespace created successfully."

# Apply manifests
apply_manifest() {
  local file=$1
  log "Applying $file..."
  kubectl apply -f $file
  log "$file applied successfully."
}

MANIFESTS=(
  "mlflow-service-account.yaml"
  "mlflow-configmap.yaml"
  "mlflow-db-secret.yaml"
  "mlflow-pv-pvc.yaml"
  "mlflow-rbac.yaml"
  "mlflow-deployment.yaml"
  "mlflow-service.yaml"
)

for manifest in "${MANIFESTS[@]}"; do
  apply_manifest $manifest
done

log "MLflow deployment setup completed successfully!"
