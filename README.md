# MLflow Deployment on Local Minikube

This repo provides you guides the process to **build** and **deploy** **MLflow** on **Minikube** using Kubernetes. Follow the steps below to set up your  MLflow environment in local Minikube.

## Prerequisites
- **Minikube** installed and running.
- **kubectl** installed and configured for Minikube.
- **Docker** installed on your local machine.
- **postgresql** runing on minikube instance 

## Step 1: Clone the Repository
Clone the repository containing the deployment scripts and manifests:
```bash
git clone adera-infrastructure
cd adera-infrastructure/mlflow-deployment
```
## Step 2: Build and Push Docker Image
### Run the Script

Make sure your Docker daemon is running, and then execute the `build.sh` script:

```bash
chmod +x build_push.sh
./build.sh
```

This script will:

- Build the Docker image.
- Enable the Minikube registry.
- Tag and push the image to the local Minikube registry.

## Step 2: Deploy MLflow to Kubernetes
### a. Prepare Deployment Manifests

Deploy MLflow to Kubernetes using the following script, saved as `deploy.sh`:

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
