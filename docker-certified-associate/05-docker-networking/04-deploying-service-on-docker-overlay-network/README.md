# Docker Overlay Networks Deep Dive

## Table of Contents

- [Introduction](#introduction)
- [What is an Overlay Network?](#what-is-an-overlay-network)
- [Default Overlay Network: Ingress](#default-overlay-network-ingress)
- [Creating a Custom Overlay Network](#creating-a-custom-overlay-network)
- [Creating and Connecting Services to Custom Overlay Network](#creating-and-connecting-services-to-custom-overlay-network)
- [Testing Network Connectivity](#testing-network-connectivity)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker is an incredibly powerful tool for deploying and managing containerized applications. One of Docker's most valuable features is its networking capabilities, which enable communication between containers across multiple Docker hosts. In this guide, we will dive into Docker's overlay networks, highlighting its default and custom functionalities with practical examples to enhance your understanding.

## What is an Overlay Network?

An overlay network is a network layer constructed on top of another network. In the context of Docker, it provides the ability to facilitate communication between Docker containers across multiple Docker hosts. This becomes particularly useful when dealing with a Docker Swarm comprising multiple nodes.

Diagram:

```plaintext
┌───────────────────────────────────────────────────────┐  ┌───────────────────────────────────────────────────────┐
│Swarm Host                                             │  │Swarm Host                                             │
│                                                       │  │                                                       │
│ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐ │  │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐ │
│  Network Sandbox                                      │  │  Network Sandbox                                      │
│ │                                                   │ │  │ │                                                   │ │
│   ┌───────────────────────────────────────────────┐   │  │   ┌───────────────────────────────────────────────┐   │
│ │ │                   Container                   │ │ │  │ │ │                   Container                   │ │ │
│   └───────────────────────────────────────────────┘   │  │   └───────────────────────────────────────────────┘   │
│ │                                                   │ │  │ │                                                   │ │
│                                    ┌──────────────┐   │  │   ┌──────────────┐                                    │
│ │                                  │   Endpoint   │ │ │  │ │ │   Endpoint   │                                  │ │
│                                    └───────┬──────┘   │  │   └──────┬───────┘                                    │
│ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│─ ─ ─ ─ ┘ │  │ └ ─ ─ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘ │
│                                            │          │  │          │                                            │
│                                            │          │  │          │                                            │
│                                    ┌───────┴──────────┴──┴──────────┴───────┐                                    │
│                                    │            Overlay Network             │                                    │
│                                    └──────────────────┬──┬──────────────────┘                                    │
│                                                       │  │                                                       │
│                                                       │  │                                                       │
└───────────────────────────────────────────────────────┘  └───────────────────────────────────────────────────────┘

                                                 © Minh Hung Phan
```

## Default Overlay Network: Ingress

Docker Swarm utilizes a default overlay network named "ingress." To view this, use the following command:

```bash
docker network ls
```

The `docker network ls` command lists all the networks that are currently available in your Docker environment. For a Docker Swarm setup, it would show the 'ingress' network among others. Here's an example of what the output might look like:

```plaintext
NETWORK ID     NAME      DRIVER    SCOPE
30b3ea9fd9c6   bridge    bridge    local
b3924f7b8aad   host      host      local
04ada5775f38   ingress   overlay   swarm
d8b3d8d25dec   none      null      local
```

In this example, we have four networks available. They are:

1. `bridge`: The default network created by Docker. Containers connected to the same bridge network can communicate, while containers on different bridge networks cannot.

2. `host`: Removes network isolation between the Docker host and Docker containers to use the host's networking directly.

3. `ingress`: The default overlay network created when initializing a swarm or when the first service is created. Any service that doesn’t explicitly specify a different network will be connected to the ingress network.

4. `none`: This network disables all networking for the container.

It's worth noting that the `NETWORK ID` and `NAME` values in your output might differ since they are generated based on your system's configuration. The main thing to understand here is that `ingress` is the default overlay network for Docker Swarm, and unless specified otherwise, all swarm services will be connected to this network, enabling them to communicate freely.

If a service is created without specifying the network to be used, it will automatically connect to this default `ingress` network. Consequently, all such services can communicate freely as they reside on the same network. While this is convenient, it might not always be desirable, particularly if you wish to isolate certain services for security reasons.

## Creating a Custom Overlay Network

In order to create a custom overlay network, we use the command `docker network create`, specifying the driver as 'overlay'. Additionally, we can add the `--attachable` flag, which allows us to manually attach individual containers to this network.

Here's an example of creating an overlay network named 'my-overlay':

```bash
docker network create --driver overlay --attachable my-overlay
```

## Creating and Connecting Services to Custom Overlay Network

To isolate specific services or to allow communication only between certain services, we can create a service that uses our custom overlay network. In this example, we create a service named 'overlay-service' with 3 replicas, using a simple 'nginx' service:

```bash
docker service create --name overlay-service --network my-overlay --replicas 3 nginx
```

This command attaches our service to the 'my-overlay' network, enabling it to communicate with other containers within the same network.

## Testing Network Connectivity

With the 'my-overlay' network being attachable, we can use the `docker run` command to run a container that connects to it. This is how we can test if the service is properly communicating with other containers within the network. 

We'll use a radial/busyboxplus:curl container to send a curl request to our 'nginx' service:

```bash
docker run --rm --network my-overlay radial/busyboxplus:curl curl overlay-service:80
```

If the connection is successful, you should be able to see the nginx welcome page, indicating that communication across the custom overlay network is working correctly.

## Relevant Documentation

- [Docker Documentation - Overlay Network](https://docs.docker.com/network/overlay/)

## Conclusion

Understanding Docker's overlay networks is key to successfully managing communication between your services. This guide walked you through what an overlay network is, the default overlay network, how to create a custom overlay network, and finally, how to test connectivity. See you in the next lesson!

