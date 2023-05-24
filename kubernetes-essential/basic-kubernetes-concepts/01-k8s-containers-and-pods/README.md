# Containers and Pods

## Introduction
In order to run and manage containers with Kubernetes, you will need to use pods.

Pods are the smallest and most basic building block of the Kubernetes model.

A pod consists of one or more containers, storage resources, and a unique IP address in the Kubernetes cluster network.

In this tutorial, we discuss the basics of what pods are and how they are related to containers within the world of Kubernetes. We will create a simple pod and then we will look at some ways to explore and interact with pods in your Kubernetes cluster.

## Commands
Here are the commands used in this lesson:

1. Create a simple pod running an nginx container:
```bash
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
  image: nginx
EOF
```
2. et a list of pods and verify that your new nginx pod is in the Running state:
```bash
kubectl get pods
```
3. Get more information about your nginx pod:
```bash
kubectl describe pod nginx
```
4. Delete the pod:
```bash
kubectl delete pod nginx
```