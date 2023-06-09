# Building a Kubernetes 1.24 Cluster with kubeadm

##  Introduction
This lab will allow you to practice the process of building a new Kubernetes cluster. You will be given a set of Linux servers, and you will have the opportunity to turn these servers into a functioning Kubernetes cluster. This will help you build the skills necessary to create your own Kubernetes clusters in the real world.

## Solution

1. Log in to the lab servers using SSH:
```bash
ssh -i /path/to/private_key.pem username@PUBLIC_IP_ADDRESS
```

+ -i /path/to/private_key.pem: Specifies the path to the private key file associated with the key pair used when launching the EC2 instance. Replace /path/to/private_key.pem with the actual path to your private key file.
+ username: The username associated with the EC2 instance. The default username for Amazon Linux is ec2-user. For Ubuntu instances, it is ubuntu. For other distributions, refer to the specific documentation.

## Install Packages

1. Log in to the control plane node.

> Note: The following steps must be performed on all three nodes.

2. Create configuration file for containerd:
```bash
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```
3. Load modules:
```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```
4. Set system configurations for Kubernetes networking:
```bash
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
5. Apply new settings:
```bash
sudo sysctl --system
```
6. Install containerd:
```bash
sudo apt-get update && sudo apt-get install -y containerd.io
```
7. Create default configuration file for containerd:
```bash
sudo mkdir -p /etc/containerd
```
8. Generate default containerd configuration and save to the newly created default file:
```bash
sudo containerd config default | sudo tee /etc/containerd/config.toml
```
9. Restart containerd to ensure new configuration file usage:
```bash
sudo systemctl restart containerd
```
10. Verify that containerd is running:
```bash
sudo systemctl status containerd
```
11. Disable swap:
```bash
sudo swapoff -a
```
12. Install dependency packages:
```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
```
13. Download and add GPG key:
```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```
14. Add Kubernetes to repository list:
```bash
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```
15. Update package listings:
```bash
sudo apt-get update
```
16. Install Kubernetes packages:
```bash
sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00
```
> Note: If you get a `dpkg lock` message, just wait a minute or two before trying the command again
17. Turn off automatic updates:
```bash
sudo apt-mark hold kubelet kubeadm kubectl
```
18. Log in to both worker nodes to perform previous steps.

## Initialize the Cluster

1. On the control plane node, initialize the Kubernetes cluster on the control plane node using `kubeadm`:
```bash
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0
```
2. Set `kubectl` access:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
3. Test access to cluster:
```bash
kubectl get nodes
```

## Install the Calico Network Add-On

1. On the control plane node, install Calico Networking:
```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
```
2. Check status of the control plane node:
```bash
kubectl get nodes
```
## Join the Worker Nodes to the Cluster

1. In the control plane node, create the token and copy the `kubeadm join` command:
```bash
kubeadm token create --print-join-command
```
> Note: This output will be used as the next command for the worker nodes.

2. Copy the full output from the previous command used in the control plane node. This command starts with `kubeadm join`.

3. In both worker nodes, paste the full `kubeadm join` command to join the cluster. Use `sudo` to run it as root:
```bash
sudo kubeadm join...
``` 
4. In the control plane node, view cluster status:
```bash
kubectl get nodes
```
> Note: You may have to wait a few moments to allow all nodes to become ready.

## Conclusion
Congratulations — you've completed this hands-on lab!