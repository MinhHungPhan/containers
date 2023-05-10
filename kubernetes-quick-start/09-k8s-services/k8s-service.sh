#!/bin/bash

# Extract the name of the ReplicaSet from the YAML file
RS_NAME=$(grep "name:" replicaset.yml | head -n 1 | awk -F " " '{print $2}')

# Extract the name of the service from the YAML file
SERVICE_NAME=$(grep "name:" service.yml | head -n 1 | awk -F " " '{print $2}')

# Get the list of existing ReplicaSets
if kubectl get rs &> /dev/null; then
  if kubectl get rs $RS_NAME &> /dev/null; then
    echo "ReplicaSet already exists:"
    kubectl get rs $RS_NAME
  else
    echo "Creating new ReplicaSet:"
    # Create the ReplicaSet
    kubectl create -f replicaset.yml

    # Describe all the created pods and save output to file
    kubectl describe pods > pods_description.txt
  fi
else
  echo "No existing ReplicaSets found."
  # Create the ReplicaSet
  kubectl create -f replicaset.yml

  # Describe all the created pods and save output to file
  kubectl describe pods > pods_description.txt
fi

# Create the service only if it doesn't exist
if kubectl get service $SERVICE_NAME &> /dev/null; then
  echo "Service already exists."
else
  kubectl create -f service.yml
fi

# Describe the service and save output to file before the scaling
kubectl describe service $SERVICE_NAME > service_description_before_scaling.txt

# Scale the ReplicaSet to 4 replicas
kubectl scale --replicas=4 rs/$RS_NAME

# Describe the service and save output to file after the scaling
kubectl describe service $SERVICE_NAME > service_description_after_scaling.txt

# Describe the ReplicaSet and save output to file
kubectl describe rs/$RS_NAME > rs_description.txt
