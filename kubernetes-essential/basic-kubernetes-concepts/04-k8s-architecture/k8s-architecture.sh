#!/bin/bash

# Get cluster info
echo "Cluster Information:"
echo "-------------------"
kubectl cluster-info
echo

# Get nodes
echo "Nodes:"
echo "------"
kubectl get nodes -o wide
echo

# Get control plane components
echo "Control Plane Components:"
echo "------------------------"
kubectl get componentstatuses
echo

# Get detailed information about each control plane component
echo "Control Plane Component Details:"
echo "------------------------------"
component_names=$(kubectl get componentstatuses -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
for component in $component_names; do
  echo "Component: $component"
  echo "-------------------"
  kubectl describe componentstatuses "$component"
  echo
done

# Get namespaces
echo "Namespaces:"
echo "-----------"
kubectl get namespaces
echo

# Get pods in kube-system namespace
echo "Pods in kube-system Namespace:"
echo "----------------------------"
kubectl get pods -n kube-system -o wide
echo

# Get services in kube-system namespace
echo "Services in kube-system Namespace:"
echo "-------------------------------"
kubectl get services -n kube-system
echo

# Get deployments in kube-system namespace
echo "Deployments in kube-system Namespace:"
echo "---------------------------------"
kubectl get deployments -n kube-system
echo

# Get persistent volumes
echo "Persistent Volumes:"
echo "-------------------"
kubectl get pv
echo

# Get persistent volume claims
echo "Persistent Volume Claims:"
echo "------------------------"
kubectl get pvc --all-namespaces
echo
