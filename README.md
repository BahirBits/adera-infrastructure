# MLflow Deployment on Minikube

This guide provides the process to **build** and **deploy** **MLflow** on **Minikube** using Kubernetes. Follow the steps below to set up your local MLflow environment in Minikube.

## Prerequisites

- **Minikube** installed and running.
- **kubectl** installed and configured for Minikube.
- **Docker** installed on your local machine.
- **postgresql** runing on minikube instance 

## Step 1: Clone the Repository

Clone the repository containing the deployment scripts and manifests:

```bash
git clone <repository-url>
cd adera-infrastructure/mlflow-deployment
```
## Step 2: Build and Push Docker Image

First, create the Docker image for MLflow. Save the following script as `build.sh`:

```bash
#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Catch errors in pipelines

log() {
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") - $1"
}

# Define variables
IMAGE_NAME="mlflow:latest"
LOCAL_REGISTRY="localhost:5000"
MINIKUBE_IMAGE="${LOCAL_REGISTRY}/mlflow:latest"

# Build the Docker image
log "Building the Docker image..."
docker build -t $IMAGE_NAME .
log "Docker image built successfully."

# Ensure Minikube's Docker registry is running
log "Starting Minikube registry..."
minikube addons enable registry
log "Minikube registry enabled."

# Tag the image for Minikube's registry
log "Tagging the Docker image for Minikube registry..."
docker tag $IMAGE_NAME $MINIKUBE_IMAGE
log "Docker image tagged successfully."

# Push the image to Minikube's local registry
log "Pushing the Docker image to Minikube registry..."
docker push $MINIKUBE_IMAGE
log "Docker image pushed successfully."

log "Build and push process completed!"
```

### Run the Script

Make sure your Docker daemon is running, and then execute the `build.sh` script:

```bash
chmod +x build.sh
./build.sh
```

This script will:

- Build the Docker image.
- Enable the Minikube registry.
- Tag and push the image to the local Minikube registry.

## Step 2: Deploy MLflow to Kubernetes

### a. Prepare Deployment Manifests

Deploy MLflow to Kubernetes using the following script, saved as `deploy.sh`:

```bash
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
```

### Run the Script

Execute the `deploy.sh` script to deploy the MLflow application:

```bash
chmod +x deploy.sh
./deploy.sh
```

This script will:

- Create the `mlflow` namespace in Kubernetes.
- Apply all required Kubernetes manifests for deploying MLflow.

## Step 3: Monitor and Access MLflow UI

### a. Monitor the Deployment

Check the status of the MLflow deployment:

```bash
kubectl get pods -n mlflow
```

If any issues arise, describe the problematic pod to view logs:

```bash
kubectl describe pod <pod-name> -n mlflow
```

### b. Access MLflow UI

To access the MLflow UI, forward the port:

```bash
kubectl port-forward svc/mlflow-service 5000:5000 -n mlflow
```

Then, open your browser and go to [http://localhost:5000](http://localhost:5000).

## Cleanup

When you're done with the deployment, you can delete the namespace and resources:

```bash
kubectl delete namespace mlflow
```

This will remove all the resources associated with the MLflow deployment.
