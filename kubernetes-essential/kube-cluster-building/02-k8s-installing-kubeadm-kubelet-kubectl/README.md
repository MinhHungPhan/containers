# Installing Kubeadm, Kubelet, and Kubectl

## Introduction 
Now that Docker is installed, we are ready to install the Kubernetes components. In this tutorial, I will guide you through the process of installing Kubeadm, Kubelet, and Kubectl on all three playground servers. After completing this tutorial, you should be ready for the next step, which is to bootstrap the cluster.

## Commands
Here are the commands used to install the Kubernetes components in this lesson. Run these on all three servers.

### Add Kubernetes GPG key
```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```

### Add Kubernetes repository
```bash
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

### Update package lists
```bash
sudo apt-get update
```

### Install Kubernetes components
```bash
sudo apt-get install -y kubelet=1.15.7-00 kubeadm=1.15.7-00 kubectl=1.15.7-00
```

### Mark Kubernetes components as held to prevent automatic upgrades
```bash
sudo apt-mark hold kubelet kubeadm kubectl
```

### After installing these components, verify that kubeadm is working by getting the version info.
```bash
kubeadm version
```