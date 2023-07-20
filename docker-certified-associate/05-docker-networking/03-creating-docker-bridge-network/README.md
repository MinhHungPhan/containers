# Docker Bridge Networks Deep Dive 

In this tutorial, we'll take a closer look at Docker Bridge Networks. In our [previous tutorial](/docker-certified-associate/05-docker-networking/02-built-in-network-drivers/README.md), we provided a basic overview of how to use a bridge network, but here, we're delving deeper into the associated commands for creating and managing networks.

Notably, these techniques and commands aren't limited to bridge networks, they also apply to other types of network drivers like overlay networks.

## Table of Contents

- [Introduction](#introduction)
- [Create a Network](#create-a-network)
- [Understanding Docker's Embedded DNS](#understanding-dockers-embedded-dns)
- [Working with Network Aliases](#working-with-network-aliases)
- [Managing Docker Networks](#managing-docker-networks)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Bridge networks facilitate communication between Docker containers on the same host. This tutorial aims to provide a detailed exploration of bridge networks, Docker's embedded DNS, network aliases, and various Docker network commands.

## Create a Network

Let's kick things off by creating a network. We can use the `docker network create` command to accomplish this:

```bash
docker network create my-net
```

Here, `my-net` is the name of our network. We can then run a container that uses this network:

```bash
docker run -d --name my-net-busybox --network my-net radial/busyboxplus:curl sleep 3600
```

This command runs a simple busybox container (`my-net-busybox`) on the `my-net` network. We can similarly run an nginx container:

```bash
docker run -d --name my-net-nginx nginx
```

Now, to connect the nginx container to our network, we can use `docker network connect`:

```bash
docker network connect my-net my-net-nginx
```

Finally, we can validate the connection between the two containers using the `docker exec` command:

```bash
docker exec my-net-busybox curl my-net-nginx:80
```

## Understanding Docker's Embedded DNS

Docker incorporates an embedded DNS (Domain Name System) server that allows the names of containers and services to map back to their underlying IP addresses. This way, you can easily use the name of a container (or a service, in the case of Docker Swarm) to communicate with it, without having to manually look up its IP address.

Containers can communicate with other containers and services using the service or container name, or network alias.

**How it works**:

Docker is like a big apartment building for your software, and each piece of software lives in its own apartment, which we call a "container". Now, just like how every apartment has a specific number, every Docker container has its own unique IP address.

But memorizing all these numbers can be hard, right? This is where the Domain Name System (DNS) comes into play. Docker has its own built-in "directory assistance" or DNS that helps keep track of all these addresses. It allows us to use the names of the containers instead of their IP addresses, making it much easier to find and communicate with them. 

Just think of it as calling your friend by their name instead of their phone number. Docker's DNS does the same thing—it uses the names of the containers (or 'services' when you are working with a group of containers in Docker Swarm) to find their "phone numbers" (IP addresses), so you don't have to remember them.

Let's understand this concept with an example:

```bash
docker exec my-net-busybox curl my-net-nginx:80
```

In this command, we are using the container's name (`my-net-nginx`) to communicate with it.

## Working with Network Aliases

Docker allows us to use network aliases to communicate between containers. This comes in handy when you want to change the container name or use a different name and avoid having to change all references to it in other containers.

You can assign a network alias to a Docker container directly during its creation with the `docker run` command. Here's an example of creating a container named `my-net-nginx2` with a network alias of `my-nginx-alias`:

```bash
docker run -d --name my-net-nginx2 --network my-net --network-alias my-nginx-alias nginx
```

You can substitute the container's name `my-net-nginx2` with the network alias `my-nginx-alias` like so:

```bash
docker exec my-net-busybox curl my-nginx-alias:80
```

Now, let's create another container without an alias, named `my-net-nginx3`:

```bash
docker run -d --name my-net-nginx3 nginx
```

The `docker network connect` command can be used to assign a network alias to an existing Docker container. In the following example, the network alias `another-alias` is assigned to the existing `my-net-nginx3` container:

```bash
docker network connect --alias another-alias my-net my-net-nginx3
```

Similar to the previous example, you can use the network alias `another-alias` instead of the actual container's name `my-net-nginx3` as shown below:

```bash
docker exec my-net-busybox curl another-alias:80
```

Remember that these network aliases are only recognized within the same network. Thus, it provides a simple and convenient way to reference containers within the same network.

## Managing Docker Networks

Docker also provides several commands to manage networks on your host. Some of these are:

- `docker network ls` - List all networks.
- `docker network inspect <NETWORK_NAME>` - Get detailed information about a network, including all the connected containers.
- `docker network disconnect <NETWORK_NAME> <CONTAINER_NAME>` - Disconnect a container from a network.
- `docker network rm <NETWORK_NAME>` - Delete a network. **Note**: You need to disconnect all connected containers before deleting a network.

## Relevant Documentation

- [Docker Documentation - Bridge Networks](https://docs.docker.com/network/bridge/)

## Conclusion

This tutorial provided a deep dive into Docker bridge networks, the embedded DNS, and network aliases. We also discussed various Docker network commands to manage networks on your host. Docker's networking features enhance container communication and management, making Docker an incredibly versatile tool for deploying and managing applications.


