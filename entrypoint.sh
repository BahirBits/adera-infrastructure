#!/bin/bash

export ARTIFACT_ROOT="/data/mlflow"
echo "Starting MLflow server with the following environment variables:"
echo "DB_USERNAME: $DB_USERNAME"
echo "DB_PASSWORD: $DB_PASSWORD"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_NAME: $DB_NAME"
echo "MLFLOW_PORT: $MLFLOW_PORT"
echo "ARTIFACT_ROOT: $ARTIFACT_ROOT"

# Check if any required environment variables are missing
if [ -z "$DB_USERNAME" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ] || [ -z "$DB_NAME" ]; then
  echo "Error: One or more required environment variables are missing."
  exit 1
fi

if [ -z "$ARTIFACT_ROOT" ]; then
  echo "Error: ARTIFACT_ROOT is not set."
  exit 1
fi

# Ensure the artifact root directory exists
if [ ! -d "$ARTIFACT_ROOT" ]; then
  echo "Creating artifact root directory at $ARTIFACT_ROOT"
  mkdir -p "$ARTIFACT_ROOT"
fi

# Start MLflow server
echo "Starting MLflow server on port $MLFLOW_PORT with backend store URI postgresql://$DB_HOST:$DB_PORT/$DB_NAME and artifact root $ARTIFACT_ROOT"

mlflow server \
  --host 0.0.0.0 \
  --port "$MLFLOW_PORT" \
  --backend-store-uri "postgresql://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" \
  --default-artifact-root="$ARTIFACT_ROOT"
