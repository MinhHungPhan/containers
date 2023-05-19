# Kubernetes Cluster Components

A Kubernetes cluster is made up of multiple individual components running on the various machines that are part of the cluster. In this tutorial, we will briefly discuss the major Kubernetes software components and what each of them does. We will also look into how these components are actually running in our cluster currently.

## Commands Used in This Tutorial

### Get a list of nodes running in the cluster:

```bash
kubectl get nodes -o wide
```

###  Get control plane components:
```bash
kubectl get componentstatuses
```

### Get a list of system pods running in the cluster:

```bash
kubectl get pods -n kube-system
```

### Determine which pods are running on which nodes in the kube-system namespace:

```bash
kubectl get pods -n kube-system -o wide
```

### Check the status of the kubelet service:

```bash
sudo systemctl status kubelet
```

### Get namespaces:
```bash
kubectl get namespaces
```

### Get pods in kube-system namespace:

```bash
kubectl get pods -n kube-system -o wide
```

### Get services in kube-system namespace:

```bash
kubectl get services -n kube-system
```

### Get deployments in kube-system namespace:

```bash
kubectl get deployments -n kube-system
```

### Get persistent volumes:

```bash
kubectl get pv
```

### Get persistent volume claims:

```bash
kubectl get pvc --all-namespaces
```
