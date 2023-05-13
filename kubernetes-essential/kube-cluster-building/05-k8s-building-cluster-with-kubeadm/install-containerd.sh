#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Create configuration file for containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# Load modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Set system configurations for Kubernetes networking
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply new settings
sudo sysctl --system

# Install containerd
sudo apt-get update && sudo apt-get install -y containerd.io

# Create default configuration file for containerd
sudo mkdir -p /etc/containerd

# Generate default containerd configuration and save to the newly created default file
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd to ensure new configuration file usage
sudo systemctl restart containerd

# Auto-delete this script after execution
rm -- "$0"
