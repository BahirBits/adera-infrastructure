# MLflow Deployment on Local Minikube
This repo provides a guide to **build** and **deploy** **MLflow** on **Minikube** using Kubernetes. Follow the steps below to set up your MLflow environment in local Minikube.

## Objective

- The goal of this setup is to enable model experimentation and implement a simple MLOps pipeline on your local machine. Here's what you can achieve with this setup:

  - **MLOps Pipeline Setup**: To experiment with models and implement a local MLOps pipeline, you’ll need tools like MLflow, DVC, and/or Kubeflow. While Kubeflow is powerful, it can be resource-intensive for local development, and community support is limited. Therefore, MLflow is a more practical choice for local MLOps pipelines.

  - **Minikube for Local Kubernetes**: Minikube is a great tool for running Kubernetes locally. It simulates a Kubernetes environment on your local machine, assuming you have at least 4GB of RAM and a quad-core CPU.
  
  - **PostgreSQL Setup**: You can easily deploy PostgreSQL on Minikube using Helm or by building your own Docker image. PostgreSQL will serve as the backend store for MLflow, providing an efficient solution for experiment tracking. You can refer to the `/postgres-redis-helm-deployment` directory for instructions on deploying PostgreSQL and Redis on your local Minikube setup.

  - **End-to-End Lightweight MLOps Pipeline**: This setup allows you to build a lightweight, end-to-end MLOps pipeline that tracks models, experiments, and results using MLflow.

  - **Storage Configuration**: For local development, configure MLflow's backend-store-uri to use PostgreSQL (or any SQL variant). The artifact store can be set up with a persistent volume or your local file system to store model artifacts.

  - **MLflow Tracking & Model Registry**: While experimenting with your models, you can use MLflow's tracking server to log experiments and the model registry to manage models.

  - **Replicability Across Environments**: This setup can easily be adapted to cloud-based Kubernetes environments, like AWS EKS or Google Cloud, with only minor configuration changes.

## Why This Resource?

While working with AWS EKS, I found it easy to scale my MLOps pipeline for production. For personal projects, I needed a lightweight, local solution that mirrors my cloud setup. Minikube offers a simple way to experiment with Kubernetes locally, and this setup can be easily migrated to cloud environments, making it suitable for both personal and professional use.

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
