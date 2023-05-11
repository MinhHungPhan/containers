#!/bin/bash

# Add Kubernetes GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update package lists
sudo apt-get update

# Install Kubernetes components
sudo apt-get install -y kubelet=1.15.7-00 kubeadm=1.15.7-00 kubectl=1.15.7-00

# Mark Kubernetes components as held to prevent automatic upgrades
sudo apt-mark hold kubelet kubeadm kubectl

# Auto-delete this script after execution
rm -- "$0"
