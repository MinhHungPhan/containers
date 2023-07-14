# Docker Networking Introduction

## Table of Contents

- [Introduction](#introduction)
- [Understanding the Container Networking Model](#understanding-the-container-networking-model)
- [Key Components of the Container Networking Model](#key-components-of-the-container-networking-model)
- [Endpoint vs Port](#endpoint-vs-port)
- [Network Types: Bridge and Overlay](#network-types-bridge-and-overlay)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to our guide on Docker networking, aimed at providing an in-depth understanding of how Docker manages the complex task of networking in container environments. Throughout this guide, we will focus primarily on Docker's Container Networking Model (CNM) and the multiple ways it can be implemented. We aim to make the concepts easy to grasp for beginners, and we will include several examples for clarity.

## Understanding the Container Networking Model

Docker employs the Container Networking Model (CNM) as the driving philosophy for its networking approach. The CNM is not a single implementation but a set of concepts and ideas that explain the structuring of Docker networking. Its multiple implementations allow for flexibility in aligning with varying user needs and infrastructures.

## Key Components of the Container Networking Model

To understand the CNM, we need to delve into some of its key components:

1. **Sandbox:** This term refers to an isolated network space housing the networking components associated with a single container. Each sandbox is a container with its unique networking components, implemented using network namespaces. You can think of a Docker sandbox similar to having an individual internet box or router for each house. Each router (or sandbox) controls and manages all the network traffic for its specific house (container) independently. This includes managing network interfaces, IP addresses, routing, and DNS settings.

2. **Endpoints:** Endpoints exist within sandboxes and serve as the connecting points between the container sandbox and the network. If two containers need to communicate, they will each have an endpoint connecting them to a common network. A container can be connected to multiple networks and will have one endpoint in its sandbox for each network. In other words, each sandbox/container can have any number of endpoints, but has exactly one endpoint for each network it is connected to.

3. **Network:** A network is simply multiple endpoints interconnected.

4. **Network Driver:** The Network Driver handles the actual implementation of the CNM concepts. Multiple different network drivers can be used simultaneously on the same host to construct networks that meet specific needs.

5. **IPAM Driver:** Standing for IP Address Management, the IPAM driver manages the allocation of IP addresses and subnets to networks and endpoints.

Below is an example demonstrating these concepts:

Diagram:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                Docker Networking                                                 │
│                                                                                                                  │
│                                                                                                                  │
│   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─     ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│    Network Sandbox                                   │     Network Sandbox                                   │   │
│   │                                                       │                                                      │
│     ┌──────────────────────────────────────────────┐ │      ┌──────────────────────────────────────────────┐ │   │
│   │ │                  Container                   │      │ │                  Container                   │     │
│     └──────────────────────────────────────────────┘ │      └──────────────────────────────────────────────┘ │   │
│   │                                                       │                                                      │
│                                     ┌──────────────┐ │      ┌──────────────┐                                 │   │
│   │                                 │   Endpoint   │      │ │   Endpoint   │                                     │
│                                     └────────┬─────┘ │      └──────┬───────┘                                 │   │
│   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│─ ─ ─ ─     └ ─ ─ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│                                              │                     │                                             │
│                                     ┌────────┴─────────────────────┴───────┐                                     │
│                                     │               Network                │                                     │
│                                     └──────────────────────────────────────┘                                     │
│                                                                                                                  │
│   ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────┐   │
│   │                                              Docker Engine                                               │   │
│   └──────────────────────────────────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                                                  │
│   ┌──────────────────────────────────────────────────┐    ┌──────────────────────────────────────────────────┐   │
│   │                                                  │    │                                                  │   │
│   │                  Network Driver                  │    │                  Network Driver                  │   │
│   │                                                  │    │                                                  │   │
│   └──────────────────────────────────────────────────┘    └──────────────────────────────────────────────────┘   │
│                                                                                                                  │
│   ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────┐   │
│   │                                     Underlying Network Infrastructure                                    │   │
│   └──────────────────────────────────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                                                  │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘        

                                                 © Minh Hung Phan
```

Description:

In the diagram, there are two containers, each with its own sandbox. Each sandbox contains an endpoint that connects the container to the network, allowing the two containers to communicate.

## Endpoint vs Port

Think of a Docker container as a virtual computer that can run different programs or services. To make these containers talk to each other or communicate with the outside world, we have two important concepts: endpoints and ports.

1. **Endpoint**: In Docker, an endpoint can be thought of as a point of communication. Each container has a network interface which can be seen as an endpoint in the Docker network. When you connect a container to a network, Docker creates a unique endpoint for that container on that network. This endpoint consists of a private IP address and one or more ports which the container uses to communicate with other containers or with the outside world.

2. **Port**: A port in Docker is very much like a real-life port. Just as a real-life port is a place where goods are exchanged, a port in Docker is a place where data is exchanged. In networking, a port is essentially a numbered access point on a host that networked devices use to exchange information. Each container can expose one or more ports to receive network traffic.

Let's consider a simple analogy to make this clearer. Imagine your Docker network as a town, and the individual containers as the separate houses within this town. In this scenario, the endpoint can be seen as the specific address of a house (like the house number and street name) within the town. This is what uniquely identifies the house within the Docker network (town).

The port, on the other hand, can be seen as the front door to the house. Just as you need a door to enter a house and interact with the people or things inside, you need a port to send data to and receive data from a container (house). So, the endpoint (the house's address) helps you find where the container is located in the Docker network (town), and the port (the front door) allows you to interact with the container (enter the house).

Remember, when it comes to networking, understanding these basics is key. In Docker, different types of networking configurations can be made to ensure that your containers (houses) interact properly with each other and with external applications or services. Each application in a container (house) should have its unique endpoint (address) and can expose one or more ports (doors) to allow for necessary communications.

## Network Types: Bridge and Overlay

To solidify your understanding, let's consider two scenarios that implement the CNM - the bridge network and the overlay network.

1. **Bridge Network:** This implementation of CNM operates within a single host. If we consider two containers within the same host, each container is within a sandbox and connected to the bridge network via endpoints. Thus, they can communicate with each other.

Diagram:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Single Host                                                                                                       │
│                                                                                                                  │
│   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─     ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│    Network Sandbox                                   │     Network Sandbox                                   │   │
│   │                                                       │                                                      │
│     ┌──────────────────────────────────────────────┐ │      ┌──────────────────────────────────────────────┐ │   │
│   │ │                  Container                   │      │ │                  Container                   │     │
│     └──────────────────────────────────────────────┘ │      └──────────────────────────────────────────────┘ │   │
│   │                                                       │                                                      │
│                                     ┌──────────────┐ │      ┌──────────────┐                                 │   │
│   │                                 │   Endpoint   │      │ │   Endpoint   │                                     │
│                                     └────────┬─────┘ │      └──────┬───────┘                                 │   │
│   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│─ ─ ─ ─     └ ─ ─ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│                                              │                     │                                             │
│                                              │                     │                                             │
│                                     ┌────────┴─────────────────────┴───────┐                                     │
│                                     │            Bridge Network            │                                     │
│                                     └──────────────────────────────────────┘                                     │
│                                                                                                                  │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

                                                 © Minh Hung Phan
```

Description:

Two containers are connected to a bridge network on the same host, allowing them to communicate with each other.

2. **Overlay Network:** The overlay network, on the other hand, allows for communication across multiple hosts. The same CNM concepts are present, but in this case, the overlay network spans across multiple hosts, allowing containers to communicate across these hosts.

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

Description:

Two containers on different hosts are connected via an overlay network, facilitating cross-host communication.

## Relevant Documentation

For further reading and to gain a more comprehensive understanding of Docker Networking, please refer to the official [Docker Networking Documentation](https://docs.docker.com/network/)

## Conclusion

The Docker Container Networking Model provides an adaptable and efficient way to handle networking in container environments. The understanding of key concepts such as sandbox, endpoint, network, network driver, and IPAM driver is fundamental to working with Docker networks. In upcoming lessons, we will delve deeper into the practical implementations of this model.