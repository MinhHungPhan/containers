#!/bin/bash

# Create the namespace
kubectl create namespace pod-example

# Deploy the pod
kubectl create -f ./pod-example.yml
