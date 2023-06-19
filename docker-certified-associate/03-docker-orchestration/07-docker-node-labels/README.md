# Docker Swarm Node Labels

## Table of Contents

- [Introduction](#introduction)
- [Defining Node Labels](#defining-node-labels)
- [Inspecting Node Labels](#inspecting-node-labels)
- [Constraining Task Execution With Node Labels](#constraining-task-execution-with-node-labels)
- [Balancing Task Execution With Placement Preferences](#balancing-task-execution-with-placement-preferences)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to this guide on leveraging node labels in Docker Swarm. Node labels offer an efficient way to enhance control over task execution in a Docker Swarm cluster. With labels, you can influence and even decide which nodes will or won't execute a specific service's tasks. This capability is particularly useful in scenarios where you may want to manage tasks across multiple data centers or availability zones.

## Defining Node Labels

Node labels are pieces of metadata attached to your nodes. They are essentially key-value pairs that can be used to describe various aspects of a node. The process of adding a label to a node is simple. Here is the general format for adding a label:

```bash
docker node update --label-add <KEY>=<VALUE> <NODE_NAME>
```

For example, if you want to specify availability zones for your nodes:

```bash
docker node update --label-add availability_zone=east <NODE_NAME_1>
docker node update --label-add availability_zone=west <NODE_NAME_2>
```

## Inspecting Node Labels

To view existing labels attached to a node, you can use the `docker node inspect` command with the `--pretty` flag, which improves readability:

```bash
docker node inspect --pretty <NODE_NAME>
```

## Constraining Task Execution With Node Labels

When creating a service, the `--constraint` flag can be used to limit which nodes will execute a service's tasks based on the node labels. Below are examples of how to restrict a service to run tasks only on nodes within a specific availability zone, or exclude a specific zone:

```bash
docker service create --name nginx-east --constraint node.labels.availability_zone==east --replicas 3 nginx
docker service ps nginx-east
docker service create --name nginx-west --constraint node.labels.availability_zone!=east --replicas 3 nginx
docker service ps nginx-west
```

Balancing Task Execution With Placement Preferences

The `--placement-pref` flag allows the balancing of tasks based on the values of specific node labels. Here's an example of how to evenly spread tasks across different availability zones:

```bash
docker service create --name nginx-spread --placement-pref spread=node.labels.availability_zone --replicas 3 nginx
docker service ps nginx-spread
```

This command will attempt to balance the replicas across different values for the `availability_zone` label, promoting high availability. So in simple terms, this command is telling Docker: "Create a new service called `nginx-spread`, based on the `nginx` image. This service should always have three instances running. Try to spread these instances evenly across the nodes, based on their `availability_zone` labels."

## Relevant Documentation

- Docker node update: [Add label metadata to a node](https://docs.docker.com/engine/reference/commandline/node_update/#add-label-metadata-to-a-node)
- Docker Swarm Services: [Placement Constraints](https://docs.docker.com/engine/swarm/services/#placement-constraints)

## Conclusion

In this guide, we explored Docker Swarm's node labels and their practical applications in controlling task execution. We demonstrated how to define, inspect, and utilize node labels for task constraint and balancing. We hope you find these strategies beneficial in your Docker Swarm management tasks.