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
