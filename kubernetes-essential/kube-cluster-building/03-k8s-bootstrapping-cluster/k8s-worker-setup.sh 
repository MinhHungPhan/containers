#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Prompt for the kubeadm join command
echo "Please enter the kubeadm join command you copied from the master node:"
read -r KUBEADM_JOIN_CMD

# Run the join command
${KUBEADM_JOIN_CMD}

echo "Worker node has joined the cluster. Please check the status of the nodes from the master."

# Auto-delete this script after execution
rm -- "$0"