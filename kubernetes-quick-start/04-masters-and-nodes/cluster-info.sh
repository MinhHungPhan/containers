#!/bin/bash

# Display Kubernetes nodes
echo "Kubernetes nodes:"
kubectl get nodes

# Display all Kubernetes pods in wide format
echo "All Kubernetes pods in wide format:"
kubectl get pods --all-namespaces -o wide

# Display Kubernetes pods running on a specific node
echo "Kubernetes pods running on e65da7d8381c.mylabserver.com:"
kubectl get pods --all-namespaces -o wide | grep e65da7d8381c.mylabserver.com

# Display running Docker containers
echo "Running Docker containers:"
sudo docker ps
