# Exposing Docker Containers Externally

## Table of Contents

- [Introduction](#introduction)
- [Port Publishing with Docker](#port-publishing-with-docker)
- [Examining Published Ports](#examining-published-ports)
- [Port Publishing Modes for Services](#port-publishing-modes-for-services)
- [Creating and Testing Services](#creating-and-testing-services)
- [Ingress and Host Publishing Modes in Docker Swarm](#ingress-and-host-publishing-modes-in-docker-swarm)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to this introductory guide on exposing Docker containers externally. It's often required to allow your containers to interact with external entities outside your Docker host or cluster. This can be achieved through a process known as 'Port Publishing'. This guide provides you with an easy-to-understand explanation of this concept, as well as a hands-on approach with several command-line examples. 

## Port Publishing with Docker

Port publishing enables external access to the containers. In Docker, this can be done using the `-p` flag in conjunction with the `docker run` command. For instance, let's consider an example where we want to run a simple nginx container and publish a port for it. 

```bash
docker run -d -p 8080:80 --name nginx_pub nginx
```

In the command above, `-p` flag is followed by the host port (8080) and the target port (80), separated by a colon. The host port listens on our host server, and the target port listens inside the container.

**Note**: Publishing container ports is insecure by default. Meaning, when you publish a container’s ports it becomes available not only to the Docker host, but to the outside world as well.

## Examining Published Ports

There are several ways to inspect the published ports of an existing container. One common method is the `docker port` command. For example, we can use the following command to see the existing published ports for our nginx container:

```bash
docker port nginx_pub
```

This command displays the mapping between the host port and the container port. Another way to view this information is by using the `docker ps` command, which lists all the running containers and their port mappings.

## Port Publishing Modes for Services

When publishing ports for Docker services, you can use one of two modes: 'ingress' or 'host'. 

- **Ingress**: This is the default mode that builds a `routing mesh` allowing you to access the externally published port on any node in your cluster. Your network request is then routed in a load-balanced manner to one of your service's replica containers, even if it resides on a different node.

- **Host**: This mode publishes the port directly on the host where the task is running. It will only be published on nodes running a service's replica. If you access the published port on a node, you'll get a response only from the replica running on that node, not from any other node's replicas.

## Creating and Testing Services

We will create services published in both ingress and host modes and test them.

### Ingress Mode

1. **Creating a service in ingress mode**: 

```bash
docker service create -p 8081:80 --name nginx_ingress_pub nginx
```

In the above command, we're creating an nginx service with one replica, and we're publishing port 80 of the container to port 8081 of the host.

2. **Testing the service**: 

```bash
curl localhost:8081
docker service ps nginx_ingress_pub
```

### Host Mode

1. **Creating a service in host mode**: 

```bash
docker service create -p mode=host,published=8082,target=80 --name nginx_host_pub nginx
```

In the above command, we're creating an nginx service, and we're publishing port 80 of the container to port 8082 of the host. We are explicitly specifying the host mode.

2. **Testing the service**: 

```bash
docker service ps nginx_host_pub
curl localhost:8082
```

Remember, if you try to access the service from another node, it should fail since host mode doesn't use the routing mesh.

## Ingress and Host Publishing Modes in Docker Swarm

While the ingress mode uses a routing mesh that offers more flexibility, the host mode has its own use-cases as well. For instance, host mode can be preferred to avoid the additional latency that the ingress routing mesh might introduce. If you use a global service (a service that ensures there's always one replica on each node), many of the limitations of host mode publishing are mitigated.

## Relevant Documentation

- [Networking overview](https://docs.docker.com/network/)
- [Use swarm mode routing mesh](https://docs.docker.com/engine/swarm/ingress/)
- [Docker Port Reference](https://docs.docker.com/engine/reference/commandline/port/)
- [Docker Run Reference](https://docs.docker.com/engine/reference/commandline/run/)
- [Docker Service Create Reference](https://docs.docker.com/engine/reference/commandline/service_create/)

## Conclusion

By following this tutorial, you've learned how to publish ports in Docker, examined the published ports, and learned about the two port publishing modes, ingress and host, for services in Docker Swarm. Happy Docker-ing!
