# Installing Kubeadm, Kubelet, and Kubectl

## Table of Contents

- [Introduction](#introduction)
- [Commands](#commands)
   - [Add Kubernetes GPG key](#add-kubernetes-gpg-key)
   - [Add Kubernetes repository](#add-kubernetes-repository)
   - [Update package lists](#update-package-lists)
   - [Install Kubernetes components](#install-kubernetes-components)
   - [Mark Kubernetes components as held to prevent automatic upgrades](#mark-kubernetes-components-as-held-to-prevent-automatic-upgrades)
   - [Verify kubeadm installation](#verify-kubeadm-installation)
- [Conclusion](#conclusion)
- [References](#references)

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

## Conclusion

By following this tutorial, you have successfully installed Kubeadm, Kubelet, and Kubectl on all three playground servers. You are now ready to proceed to the next step, which is to bootstrap the Kubernetes cluster. This setup ensures that your Kubernetes components are correctly installed and held at the specified versions to prevent automatic upgrades.

## References

- [Kubernetes Official Documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Kubernetes GitHub Repository](https://github.com/kubernetes/kubernetes)
- [Docker Official Documentation](https://docs.docker.com/)