#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Disable SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Enable the "br_netfilter" module for cluster communication
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Disable swap to prevent memory allocation issues
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install the Docker prerequisites
yum install -y yum-utils device-mapper-persistent-data lvm2

# Add the Docker repo and install Docker
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

# Configure the Docker Cgroup Driver to systemd, enable and start Docker
sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker --now
systemctl status docker
docker info | grep -i cgroup

# Add the Kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
      https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes
yum install -y kubelet-1.14.0 kubeadm-1.14.0 kubectl-1.14.0 kubernetes-cni-0.7.5

# Enable Kubernetes. The kubelet service will not start until you run kubeadm init
systemctl enable kubelet
