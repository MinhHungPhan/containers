#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Disable swap
sudo swapoff -a

# Add Kubernetes GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update package lists
sudo apt-get update

# Install Kubernetes components
sudo apt-get install -y kubelet=1.15.7-00 kubeadm=1.15.7-00 kubectl=1.15.7-00 kubernetes-cni-0.7.5

# Mark Kubernetes components as held to prevent automatic upgrades
sudo apt-mark hold kubelet kubeadm kubectl

# Auto-delete this script after execution
rm -- "$0"

