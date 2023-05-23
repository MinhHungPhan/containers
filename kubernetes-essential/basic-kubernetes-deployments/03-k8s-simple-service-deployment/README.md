# Deploying a Simple Service to Kubernetes

## Introduction
Deployments and services are at the core of what makes Kubernetes a great way to manage complex application infrastructures. In this hands-on lab, you will have an opportunity to get hands-on with a Kubernetes cluster and build a simple deployment, coupled with a service providing access to it. You will create a deployment and a service which can be accessed by other pods in the cluster.

## Prerequisites

To do this lab, you need to ensure that you have the following prerequisites

1. Virtual or Physical Machines: You need a set of virtual or physical machines that will serve as the nodes in your Kubernetes cluster. These machines should meet the minimum hardware requirements, such as sufficient CPU, memory, and disk space, to run the desired workload.

2. Operating System: The machines in your cluster should run a compatible operating system. Kubernetes supports various operating systems, including Linux distributions like Ubuntu, CentOS, and Fedora.

3. Container Runtime: Kubernetes relies on a container runtime to run and manage containers. Docker is the most commonly used container runtime, but other options like containerd, CRI-O, or rkt can also be used.

4. Networking: Your cluster should have a functional networking setup. The nodes in the cluster must be able to communicate with each other over a network, and each node should have a unique IP address.

5. Container Images: Determine the container images that your applications will use and ensure they are available either from a public container registry (like Docker Hub) or from a private registry within your network.

6. Networking Solution: Kubernetes requires a networking solution that allows pods and services to communicate with each other. Networking solutions like Flannel, Calico, or Weave can be used for this purpose.

7. DNS Resolution: Ensure that DNS resolution is properly configured in your cluster. Kubernetes relies on DNS for service discovery and resolving service names to IP addresses.

8. Kubernetes Cluster
- For server 1: Kube Master
- For server 2: Kube Node 1
- For server 3: Kube Node 2

9. busybox installed as a pod

To create a pod named "busybox" based on the "radial/busyboxplus:curl" image, you can use a YAML manifest file. Here's an example of how to create the pod:

1. Create a file named busybox-pod.yml (or any name of your choice) and open it in a text editor.

2. Add the following content to the busybox-pod.yml file:

```bash
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    command:
      - sleep
      - "3600"  # Sleep for 1 hour (adjust as needed)
```

In this example, the pod specification includes a single container named "busybox" based on the "radial/busyboxplus:curl" image. The container executes the sleep command to keep the pod running for 1 hour. You can modify the command or add additional configurations according to your requirements.

3. Save the busybox-pod.yml file.

4. Apply the YAML manifest using the kubectl apply command:

```bash
kubectl apply -f busybox-pod.yml
```

This command will create the pod named "busybox" based on the specified YAML manifest.

5. Verify that the pod is created and running by running the kubectl get pods command:

```bash
kubectl get pods
```

You should see the "busybox" pod in the output with the status "Running".

## Solution

Begin by logging in to the Kubernetes Master server using SSH:

```bash
ssh cloud_user@PUBLIC_IP_ADDRESS
```

### Create a deployment for the store-products service with four replicas

1. Log in to the Kube master node.

2. Create the deployment with four replicas:

```bash
cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: store-products
  labels:
    app: store-products
spec:
  replicas: 4
  selector:
    matchLabels:
      app: store-products
  template:
    metadata:
      labels:
        app: store-products
    spec:
      containers:
      - name: store-products
        image: linuxacademycontent/store-products:1.0.0
        ports:
        - containerPort: 80
EOF
```
###  Create a store-products service and verify that you can access it from the busybox testing pod

1. Create a service for the store-products pods:

```bash
cat << EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  name: store-products
spec:
  selector:
    app: store-products
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
EOF
```

2. Make sure the service is up in the cluster:

```bash
kubectl get svc store-products
```
The output will look something like this:

```bash
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
store-products   ClusterIP   10.104.11.230   <none>        80/TCP    59s
```

3. Use kubectl exec to query the store-products service from the busybox testing pod.

```bash
kubectl exec busybox -- curl -s store-products
```