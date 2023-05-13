#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Disable swap
sudo swapoff -a

# Install dependency packages
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Download and add GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes to repository list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update package listings
sudo apt-get update

# Install Kubernetes packages
sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00

# Turn off automatic updates
# Mark Kubernetes components as held to prevent automatic upgrades
sudo apt-mark hold kubelet kubeadm kubectl

# Auto-delete this script after execution
rm -- "$0"