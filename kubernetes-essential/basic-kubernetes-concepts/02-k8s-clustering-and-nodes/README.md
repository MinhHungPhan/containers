# Clustering and Nodes

## Introduction
Nodes are an essential part of the Kubernetes cluster. They are the machines where your cluster's container workloads are
executed. In this tutorial, we will discuss what nodes are in Kubernetes, and we will explore some ways in which you can find
information about nodes in your cluster.

## Concepts
Kubernetes implements a clustered architecture. In a typical production environment, you will have multiple servers capable of running your workloads (containers).

These servers, which actually run the containers, are called nodes.

A Kubernetes cluster has one or more control servers that manage and control the cluster and host the Kubernetes API. These control servers are usually separate from worker nodes, which run applications within the cluster.

## Commands 

Here are the commands used in this tutorial:

1. Get a list of nodes:
```bash
kubectl get nodes
```
2. Get more information about a specific node:
```bash
kubectl describe node $node_name
```
