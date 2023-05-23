# Deploying the Robot Shop App

## Introduction
Kubernetes is a powerful tool for managing and deploying microservice applications. In this tutorial, we will deploy a
microservice application consisting of multiple varied components to our cluster. We will also explore the application briefly in
order to get a hands-on glimpse of what a microservice application might look like, and how it might run in a Kubernetes
cluster.

## Prerequisites
To install Git on CentOS 7, you can use the following command:

```bash
sudo yum install git
```

Make sure you have administrative privileges on the system to execute the command. This command will use the yum package manager to download and install Git and its dependencies from the default CentOS repositories.

## Note
Please note: If you have followed along with this project, you have assigned nginx to port 30080 and will need to remove
this service in order for the Robot Shop App to work. You can do so by using the following command:

```bash
kubectl delete svc nginx-service
```

Here are the commands used in the demonstration to deploy the Stan's Robot Shop application:

### Clone the Git repository:

```bash
cd ~/
git clone https://github.com/linuxacademy/robot-shop.git
```

### Create a namespace and deploy the application objects to the namespace using the deployment descriptors from the Git repository:

```bash
kubectl create namespace robot-shop
kubectl -n robot-shop create -f ~/robot-shop/K8s/descriptors/
```

### Get a list of the application's pods and wait for all of them to finish starting up:

```bash
kubectl get pods -n robot-shop -w
```

Once all the pods are up, you can access the application in a browser using the public IP of one of your Kubernetes
servers and port 30080:

```bash
http://$kube_server_public_ip:30080
```