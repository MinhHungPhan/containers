#!/bin/bash

# Extract the name of the ReplicaSet from the YAML file
RS_NAME=$(grep "name:" replicaset.yml | head -n 1 | awk -F " " '{print $2}')

# Create the ReplicaSet
kubectl create -f replicaset.yml

# Scale the ReplicaSet to 4 replicas
kubectl scale --replicas=4 rs/$RS_NAME

# Update the image used by the ReplicaSet
kubectl set image rs/$RS_NAME nginx=nginx:1.21.1

# Check the status of the ReplicaSet and save output to file
kubectl get rs/$RS_NAME > rs_status.txt

# Describe the ReplicaSet and save output to file
kubectl describe rs/$RS_NAME > rs_description.txt
