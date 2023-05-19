#!/bin/bash

# Check network connectivity to nodes
echo "Checking network connectivity to nodes..."
kubectl get nodes -o wide | awk '{print $6}' | tail -n +2 | while read -r node_ip; do
  echo "Ping result for node with IP: $node_ip"
  ping -c 4 "$node_ip"
  echo
done

# Check network connectivity to services
echo "Checking network connectivity to services..."
kubectl get services --all-namespaces -o wide | awk '{print $4}' | tail -n +2 | while read -r service_ip; do
  echo "Ping result for service with IP: $service_ip"
  ping -c 4 "$service_ip"
  echo
done

# Check network connectivity between pods
echo "Checking network connectivity between pods..."
kubectl get pods --all-namespaces -o wide | awk '{print $7}' | tail -n +2 | while read -r pod_ip; do
  echo "Ping result for pod with IP: $pod_ip"
  ping -c 4 "$pod_ip"
  echo
done

# Check pod network information
echo "Checking pod network information..."
kubectl get pods --all-namespaces -o wide | awk '{print $1,$2,$3,$4,$5,$6,$7}' | tail -n +2

# Auto-delete this script after execution
rm -- "$0"
