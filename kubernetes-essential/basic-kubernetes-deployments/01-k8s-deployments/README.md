# Deploying in Kubernetes

## Introduction
Deployments are an important tool if you want to take full advantage of the automation capabilities provided by Kubernetes. In this tutorial, we will discuss what deployments are and briefly mention some common use cases for Kubernetes deployments. We will also create a simple deployment in our cluster and explore how we can interact with it.

## Here are the commands used in this tutorial:

### Create a deployment:

```bash
cat <<EOF | kubectl create -f -apiVersion: apps/v1
kind: Deployment
metadata: 
  name: nginx-deployment  
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

### Get a list of deployments:

```bash
kubectl get deployments
```

### Get more information about a deployment:

```bash
kubectl describe deployment nginx-deployment
```

### Get a list of pods:

```bash
kubectl get pods
```

You should see two pods created by the deployment.