# Docker Services Introduction

This tutorial covers Docker services. Docker services are the simplest way to leverage a Docker Swarm cluster. You'll learn how to create, manage, and update services, and we'll discuss several important concepts related to Docker services.

## Table of Contents:

- [Introduction](#introduction)
- [Creating a Simple Service](#creating-a-simple-service)
- [Creating a More Complex Service](#creating-a-more-complex-service)
- [Using Templates in Service Creation](#using-templates-in-service-creation)
- [Managing Services](#managing-services)
- [Modifying Services](#modifying-services)
- [Understanding Global vs Replicated Services](#understanding-global-vs-replicated-services)
- [Scaling Services](#scaling-services)
- [Additional Resources](#additional-resources)
- [Conclusion](#conclusion)

## Introduction

A Docker service specifies a set of one or more replica tasks that will be distributed across the different nodes in a swarm cluster. Essentially, tasks can be thought of as containers, and a service is simply a collection of one or more replica tasks. You can run multiple replicas or copies of your containerized application using a Docker service.

```plaintext                                                                                                      
                                                               task                container          
                                                                |                      |              
                                                      +---------+----------------------+-------------+
                                                      |         |                      |             |
                                                      | +-------+----------------------+-----------+ |
                                                      | |       |                      |           | |
                                                      | |       |              +-------+----------+| |
                                                      | |       |              |       |          || |
                                                      | |     nginx.1          |   nginx:latest   || |
                                               +----->| |                      |                  || |
                                               |      | |                      +------------------+| |
                 service                       |      | +------------------------------------------+ |
                    |                          |      |                                              |
+-------------------+--------------------+     |      +----------------------------------------------+
|                   |                    |     |                         available node               
|                   |                    |     |                                                      
|                   |                    |     |      +----------------------------------------------+
|                   |                    +-----+      |                                              |
|   +---------------+---------------+    |            | +------------------------------------------+ |
|   |               |               |    |            | |                                          | |
|   |               |               |    |            | |                      +------------------+| |
|   |               |               |    |            | |                      |                  || |
|   |       3 nginx replicas        |    +----------->| |     nginx.2          |   nginx:latest   || |
|   |                               |    |            | |                      |                  || |
|   |                               |    |            | |                      +------------------+| |
|   |                               |    |            | +------------------------------------------+ |
|   +-------------------------------+    |            |                                              |
|                                        +-----+      +----------------------------------------------+
|                                        |     |                         available node               
|                                        |     |                                                      
|             Swarm Manager              |     |      +----------------------------------------------+
+----------------------------------------+     |      |                                              |
                                               |      | +------------------------------------------+ |
                                               |      | |                                          | |
                                               |      | |                      +------------------+| |
                                               +----->| |                      |                  || |
                                                      | |     nginx.3          |   nginx:latest   || |
                                                      | |                      |                  || |
                                                      | |                      +------------------+| |
                                                      | +------------------------------------------+ |
                                                      |                                              |
                                                      +----------------------------------------------+
                                                                         available node               
                                                                                                      
© Minh Hung Phan
```                 

## Creating a Simple Service

Here's how you can create a simple service running the nginx image:

```bash
docker service create nginx
```

This command is quite similar to `docker run` and many of the same flags and options apply.

## Creating a More Complex Service

Let's create a more complex service, where we specify a name, multiple replicas, and a published port:

```bash
docker service create --name nginx --replicas 3 -p 8080:80 nginx
```

With multiple replicas, the exposed port will be transparently balanced between those replicas, effectively load balancing your traffic. 

You can access any of those replicas just by hitting localhost at port 8080:

```bash
curl localhost:8080
```

## Using Templates in Service Creation

You can use templates when creating services. Here's an example where we pass the node hostname to each container as an environment variable:

```bash
docker service create --name node-hostname --replicas 3 --env NODE_HOSTNAME="{{.Node.Hostname}}" nginx
```

This technique utilizes Go templates to specify a dynamic value, making each container aware of the hostname of the node it's running on.

## Managing Services

You can manage your services using the following commands:

```bash
docker service ls
docker service ps nginx
docker service inspect nginx
docker service inspect --pretty nginx
```

These commands allow you to list services, list tasks for a service, and inspect a service respectively.

## Modifying Services

You can make changes to a service using the `docker service update` command. For instance, you can change the number of replicas:

```bash
docker service update --replicas 2 nginx
```

To delete a service, you can use `docker service rm`:

```bash
docker service rm nginx
```

## Understanding Global vs Replicated Services

Services with replicas are known as replicated services, where you specify a specific number of replicas that are balanced across all of your nodes. You can also create global services, which automatically run one instance of your container on every node in your swarm:

```bash
docker service create --name nginx --mode global nginx
```

## Scaling Services

Scaling a service is a matter of changing the number of replicas. You can do this with the `docker service update` command, or the `docker service scale` command, which is a shortcut for updating the number of replicas:

```bash
docker service scale nginx=5
```

This will scale your service to five replicas.

## Additional Resources

You may want to refer to the following official Docker documentation for additional insights:
- [Services](https://docs.docker.com/engine/swarm/services/)
- [How Swarm Mode Works - Services](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/)
- [Service Create](https://docs.docker.com/engine/reference/commandline/service_create/)

## Conclusion

In this tutorial, we have discussed Docker services, which are a fundamental aspect of Docker Swarm. We have looked at how to create, manage, and update services, and we have explored several important concepts related to Docker services.