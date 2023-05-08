#!/bin/bash

# Run 'ip route' and save output to file
echo "Running 'ip route' command..."
echo "Command: ip route" > ip_route.txt
ip route >> ip_route.txt
echo "Done."

# Run 'ps -ax | grep [f]lannel' and save output to file
echo "Running 'ps -ax | grep [f]lannel' command..."
echo "Command: ps -ax | grep [f]lannel" > flannel.txt
ps -ax | grep [f]lannel >> flannel.txt
echo "Done."

# Run 'kubectl get pods --all-namespaces -o wide' and save output to file
echo "Running 'kubectl get pods --all-namespaces -o wide' command..."
echo "Command: kubectl get pods --all-namespaces -o wide" > kubectl_pods.txt
kubectl get pods --all-namespaces -o wide >> kubectl_pods.txt
echo "Done."

# Run 'kubectl get nodes' and save output to file
echo "Running 'kubectl get nodes' command..."
echo "Command: kubectl get nodes" > kubectl_nodes.txt
kubectl get nodes >> kubectl_nodes.txt
echo "Done."