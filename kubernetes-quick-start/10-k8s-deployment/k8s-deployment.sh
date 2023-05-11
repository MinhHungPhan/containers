#!/bin/bash

# Extract the name of the Deployment from the YAML file
DEPLOYMENT_NAME=$(grep "name:" deployment.yml | head -n 1 | awk -F " " '{print $2}')

# Extract the name of the service from the YAML file
SERVICE_NAME=$(grep "name:" service.yml | head -n 1 | awk -F " " '{print $2}')

# Check if a Deployment already exists
if kubectl get deployment $DEPLOYMENT_NAME &> /dev/null; then
  echo "Deployment already exists:"
  kubectl get deployment $DEPLOYMENT_NAME
else
  echo "Creating new Deployment:"
  # Create the Deployment
  kubectl create -f deployment.yml

  # Describe all the created pods and save output to file
  kubectl describe pods > pods_description.txt
fi

# Create the service only if it doesn't exist
if kubectl get service $SERVICE_NAME &> /dev/null; then
  echo "Service already exists."
else
  kubectl create -f service.yml
fi

# Wait until all pods are running
echo "Waiting for all pods to be running..."
while true; do
  RUNNING_PODS=$(kubectl get pods | grep $DEPLOYMENT_NAME | awk '{print $3}')
  if [[ $RUNNING_PODS == *"Running"* ]]; then
    echo "All pods are running."
    break
  else
    sleep 5
  fi
done

# Get the list of existing pods before the update
echo "Pods before the update..."
kubectl get pods > list_pods_before_update.txt

# Describe the deployment and save output to file before the update
kubectl describe deployment $DEPLOYMENT_NAME > deployment_description_before_update.txt

#Update the image for the 'nginx' container in the deployment to version 2
kubectl set image deployment.v1.apps/$DEPLOYMENT_NAME nginx=darealmc/nginx-k8s:v2

# Wait until all pods are running again
echo "Waiting for all pods to be running after update..."
while true; do
  RUNNING_PODS=$(kubectl get pods | grep $DEPLOYMENT_NAME | awk '{print $3}')
  if [[ $RUNNING_PODS == *"Running"* ]]; then
    echo "All pods are running."
    break
  else
    sleep 5
  fi
done

# Get the list of existing pods after the update
echo "Pods after the update..."
kubectl get pods > list_pods_after_update.txt

# Describe the deployment and save output to file after the update
kubectl describe deployment $DEPLOYMENT_NAME > deployment_description_after_update.txt

#It is recommended to terminate the deployment first, and then the associated service.

# Delete the Deployment
# kubectl delete deployment $DEPLOYMENT_NAME

# Delete the Service
# kubectl delete service $SERVICE_NAME
