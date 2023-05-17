#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Initialize the cluster using the IP range for Flannel
# Run kubeadm init command and capture the output
INIT_OUTPUT=$(sudo kubeadm init --pod-network-cidr=10.244.0.0/16)

# Extract the kubeadm join command from the output
JOIN_COMMAND=$(echo "$INIT_OUTPUT" | awk '/kubeadm join/{flag=1} /EOF/{print;flag=0} flag')

# Save the join command to a text file
echo "$JOIN_COMMAND" > join_command.txt

# Set up the local kubeconfig for the current user
USER_HOME=$(eval echo ~${SUDO_USER})
KUBECONFIG_DIR="${USER_HOME}/.kube"

mkdir -p "${KUBECONFIG_DIR}"
cp -i /etc/kubernetes/admin.conf "${KUBECONFIG_DIR}/config"
chown $(id -u ${SUDO_USER}):$(id -g ${SUDO_USER}) "${KUBECONFIG_DIR}/config"

# Deploy Flannel
sudo -u ${SUDO_USER} kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel-old.yaml
