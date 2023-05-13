#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Initialize the cluster using the IP range for Calico
# Run kubeadm init command and capture the output
INIT_OUTPUT=$(kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0)

# Extract the kubeadm join command from the output
JOIN_COMMAND=$(echo "$INIT_OUTPUT" | awk '/kubeadm join/{flag=1} /EOF/{print;flag=0} flag')

# Save the join command to a text file
echo "$JOIN_COMMAND" > join_command.txt

# Set up the local kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico in the cluster by running this only on the Master node
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# Auto-delete this script after execution
rm -- "$0"