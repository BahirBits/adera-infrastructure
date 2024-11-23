# Use Python 3.8 as the base image
FROM python:3.8

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        # Add additional system-level packages here
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /opt/program/mlflow
WORKDIR /opt/program/mlflow

# Copy the entrypoint script and requirements file into the container
COPY entrypoint.sh requirements.txt ./

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Set environment variables
ENV MLFLOW_PORT 5000

# Expose the MLflow port
EXPOSE $MLFLOW_PORT

# Set execute permission for the entrypoint script
RUN chmod +x entrypoint.sh

# Specify the entrypoint script to run when the container starts
ENTRYPOINT ["./entrypoint.sh"]
