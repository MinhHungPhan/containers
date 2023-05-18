# Networking in Kubernetes

## Introduction
Networking is an important part of understanding the basics of Kubernetes. This project provides a high-level overview of what a Kubernetes virtual cluster network looks like. We will also demonstrate how the network functions by contacting one pod from another pod over the virtual network.

### Create a deployment with two nginx pods:

```bash
cat << EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.4
        ports:
        - containerPort: 80
EOF
```

### Create a busybox pod to use for testing:

```bash
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    args:
    - sleep
    - "1000"
EOF
```

### Get the IP addresses of your pods:

```bash
kubectl get pods -o wide
```

### Get the IP address of one of the nginx pods, then contact that nginx pod from the busybox pod using the nginx pod's IP address:

```bash
kubectl exec busybox -- curl $nginx_pod_ip
```