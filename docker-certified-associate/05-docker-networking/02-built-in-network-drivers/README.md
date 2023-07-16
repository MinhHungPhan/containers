# Docker Network Drivers

## Table of Contents

- [Introduction](#introduction)
- [Docker Networking Basics](#docker-networking-basics)
- [Host Network Driver](#host-network-driver)
- [Bridge Network Driver](#bridge-network-driver)
- [Overlay Network Driver](#overlay-network-driver)
- [MACVLAN Network Driver](#macvlan-network-driver)
- [None Network Driver](#none-network-driver)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker, a popular containerization platform, offers various networking drivers, each designed for specific use cases. Understanding these drivers can provide deeper insights into Docker's networking capabilities. This guide will provide a simple explanation of Docker's native network drivers, their use cases, and examples to demonstrate their functionality.

## Docker Networking Basics

Docker provides a robust and flexible networking model that allows containers to communicate with each other and with the outside world. Here are some key concepts:

### eth0

`eth0` is a network interface in a Linux system. In the context of Docker, each container has its own `eth0` interface. You can think of this as the container's own personal doorway to the network world. It's like the front door of a house, where all incoming and outgoing traffic passes through.

### veth

`veth`, short for Virtual Ethernet devices, are a pair of connected interfaces. When a packet is sent into one end, it comes out the other, and vice versa. In Docker, when a container is created, a `veth` pair is also created. One end is attached to the `docker0` bridge on the host, and the other end goes inside the container and is connected to the `eth0` interface.

Think of `veth` as a pipe connecting two houses. If you send something into one end of the pipe, it comes out the other end. The pipe itself doesn't need an address because it's not a destination; it's just a conduit.

Explanation:

In a Docker context, when a container is created, a pair of veth interfaces is also created. One end of this pair (let's call it vethA) is placed inside the container's network namespace and connected to the container's eth0. The other end (vethB) remains in the host's network namespace and is attached to the Docker bridge (docker0).

Now, here's the key part: these veth pairs are like a tunnel or a pipe. They don't need their own IP addresses because they're not the source or destination of the network traffic. They're just the conduit through which the traffic flows. When a packet is sent from the container's eth0, it goes into `vethA`, through the pipe, comes out of `vethB`, and then goes onto the Docker bridge, and vice versa.

So, the veth interfaces are what connect the container's eth0 to the Docker bridge, but they do it by transporting the packets between them, not by having their own IP addresses. It's like how a road can connect two houses without having its own house number.

### docker0

`docker0` is a virtual bridge that Docker automatically creates on your host machine when you install Docker. It's like a big switch inside your computer, connecting all your Docker containers to each other and to the outside world.

When a `veth` pair is created for a container, one end is connected to the `docker0` bridge. This allows the container to communicate with other containers and with the host machine.

## Host Network Driver

### Concepts

The host network driver removes network isolation between the Docker host and Docker containers, enabling containers to use the host's networking directly.

The Host Network Driver offers a mechanism through which containers can interact directly with the host's network stack.

- **Direct Resource Utilization**: This system allows containers to utilize the host's networking resources in a direct manner.

- **Shared Network Namespace**: Contrary to the sandboxed approach, when using the Host Network Driver, all containers on a host will share the same network namespace.

- **Exclusive Port Usage**: It's critical to note that no two containers can use identical ports under this driver model.

- **Use Cases**: The Host Network Driver is particularly beneficial in situations where simplicity and ease of setup are crucial. This typically applies when operating one or a few containers on a single host.

Diagram:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Single Host                                                                                                       │
│                                                                                                                  │
│   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│    Host Network Namespace                                                                                    │   │
│   │                                                                                                              │
│     ┌──────────────────────────────────────────────┐        ┌──────────────────────────────────────────────┐ │   │
│   │ │                                              │        │                                              │     │
│     │                  Container                   │        │                  Container                   │ │   │
│   │ │                                              │        │                                              │     │
│     └──────────────────────────────────────────────┘        └──────────────────────────────────────────────┘ │   │
│   │                                                                                                              │
│                               ┌────────────────────┐        ┌────────────────────┐                           │   │
│   │                           │ eth0: 172.31.29.11 │        │ eth0: 172.31.29.11 │                               │
│                               └──────────┬─────────┘        └──────────┬─────────┘                           │   │
│   │                                      │                             │                                         │
│                                          │                             │                                     │   │
│   │                                      │                             │                                         │
│                               ┌──────────┴─────────────────────────────┴─────────┐                           │   │
│   │                           │             Host eth0: 172.31.29.11              │                               │
│                               └──────────────────────────────────────────────────┘                           │   │
│   │                                                                                                              │
│    ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘   │
│                                                                                                                  │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

                                                © Minh Hung Phan
```

Description:

Think of the Host Network Driver like a bridge that allows containers (these are isolated environments where your software runs) to directly use the internet connection of the host (the computer where the containers are running).

• **Using Internet Resources**: It's like the containers are borrowing the host's internet connection.

• **Sharing the Same 'Internet Identity'**: All containers running on the same host computer using this Host Network Driver will appear to the internet as if they are the same entity. This is a bit like multiple users sharing the same Wi-Fi at home; to the outside world, they all appear as the same internet connection.

• **One at a Time on the Same Port**: Like in a house where only one device can use a specific plug socket at a time, no two containers can use the same port (a specific 'gate' to the internet) at the same time.

• **Ideal Use Cases**: This Host Network Driver is a simple and easy way to connect your containers to the internet. It's a good choice when you only have one or a few containers running on the same computer (the host).

### Hands-On

Here's a step-by-step guide on how to create a container that uses the host's network interface directly, check the network interface, and attempt a connection using the host network.

1. **Create a container that uses the host's network interface directly**

We will be creating two containers, one running a BusyBox image with curl installed, and another running an Nginx server. Both containers will be configured to use the host's network interface directly.

```bash
docker run -d --net host --name host_busybox radial/busyboxplus:curl sleep 3600
docker run -d --net host --name host_nginx nginx
```

2. **Check the network interface**

We will check the network interface of the host and the BusyBox container. We are specifically interested in the `eth0` interface, which is typically the primary network interface.

```bash
ip add | grep eth0
docker exec host_busybox ip add | grep eth0
```

Observe that the IP addresses, along with all other pertinent information, perfectly correspond with the host. This match arises from our containers' direct utilization of the eth0 device. Essentially, our containers operate on the same network infrastructure that the host itself utilizes.

In simple terms, the unique identification numbers (known as IP addresses) and all other important details you see match exactly with those of the host. This is because our containers - which are lightweight, standalone, and executable software packages - are directly using something called the `eth0` device.

The `eth0` device is like a path through which these containers can communicate with other systems. In effect, our containers are using the same communication paths that the host (or main computer) uses. This means they're operating on the same network system as the host. This sharing of the network system makes it easier for them to talk to the host and other devices or software in the network.

3. **Attempt to connect using the host network**

We will attempt to connect to the localhost on port 80 from both the host and the BusyBox container. This will test if the containers are indeed using the host's network interface.

```bash
docker exec host_busybox curl localhost:80
curl localhost:80
```

When you input `curl localhost:80` in your command line, you are basically trying to access the information provided by the service that is 'listening' or operating on port 80 of your computer.

In our case, we have an Nginx container (Nginx is a type of web server software) listening on port 80, which is why we receive a response when we use the `curl` command.

Now, here's something fascinating - we can use the same `curl localhost:80` command directly from the host (the main computer on which the containers are running), and still receive a response from our Nginx container. 

Normally, it's not easy to communicate with the internal ports of a container (like port 80 in this case) without using certain options like the `-p` flag, which publishes or makes these ports accessible. 

However, in our setup, we can reach it directly, without any additional steps. This is possible because we're not using a typical 'sandboxed' or isolated container environment. Instead, we're utilizing the host's network driver, which allows direct communication. This approach gives us the ability to communicate with our containers just as if they were regular applications running on our host computer.

## Bridge Network Driver

### Concepts

The bridge network driver is the default network driver for Docker. It creates a private internal network on the host, allowing containers connected to the same bridge network to communicate with each other.

The Bridge Network Driver is a tool that Docker uses to help containers talk to each other. It uses something called Linux bridge networks to do this. Here's what you need to know:

- **What it does**: The Bridge Network Driver is like a big switchboard that connects all the containers on the same computer (host). It's the default way that Docker connects containers that are running on the same host. This means if you're not using something like a Docker swarm (which is a group of hosts), you're probably using the Bridge Network Driver.

- **How it works**: For each Docker network you create, the Bridge Network Driver creates a Linux Bridge. Think of this like a separate switchboard for each network. 

- **The default bridge**: There's a special Linux bridge network that's created automatically called `docker0`. If you don't tell your containers to connect to a specific network, they'll connect to this `docker0` bridge network by default.

- **When to use it**: The Bridge Network Driver is great when you want to create a private network for your containers on a single host. This is like having a private chat room for your containers where they can talk to each other without being disturbed.

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
│                                 ┌──────────────────┐ │      ┌──────────────────┐                             │   │
│   │                             │ eth0: 172.17.0.2 │      │ │ eth0: 172.17.0.3 │                                 │
│                                 └────────┬─────────┘ │      └────────┬─────────┘                             │   │
│   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│─ ─ ─ ─ ─ ─     └ ─ ─ ─ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│                                          │                           │                                           │
│                                          │                           │                                           │
│                                 ┌────────┴─────────┐        ┌────────┴─────────┐                                 │
│                                 │       veth       │        │       veth       │                                 │
│                                 └────────┬─────────┘        └────────┬─────────┘                                 │
│                                          │                           │                                           │
│                                          │                           │                                           │
│                                  ┌───────┴───────────────────────────┴─────────┐                                 │
│                                  │             docker0: 172.17.0.1             │                                 │
│                                  └──────────────────────┬──────────────────────┘                                 │
│                                                         │                                                        │
│                                                         │                                                        │
│                                            ┌────────────┴───────────┐                                            │
│                                            │ Host eth0: 192.168.1.5 │                                            │
│                                            └────────────────────────┘                                            │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

                                                © Minh Hung Phan
```

Description:

1. **eth0 (2 containers)**: Think of each container as a separate little computer inside your main computer (the host). Each of these little computers needs an address so that they can talk to each other and to the host. So, for example, we could give Container 1 the address 172.17.0.2 and Container 2 the address 172.17.0.3.

2. **eth0 (host)**: This is the address of your main computer (the host) on your home or office network. It's like the street address for your house. This could be something like 192.168.1.5.

3. **veth**: These are like the roads that connect your little computer houses (containers) to the main road (the docker0 bridge). They don't have their own addresses because they're just the roads, not the houses. But they transport the network packets between the host and the containers. One end of the veth pair is connected to the Docker bridge (docker0), while the other end is connected to the eth0 interface inside the container.

4. **docker0**: This is like the main road or bridge that all your little computer houses (containers) connect to. It has its own address, like 172.17.0.1, which is like the address of the main road.

With these concepts, you can start to understand how Docker networking works. Remember, each container has its own `eth0` interface (its own front door), and it communicates with the outside world through a `veth` pipe that connects to the `docker0` bridge (the main road).

### Hands-On

Here's a step-by-step guide on how to create a custom bridge network in Docker, create two containers on this network, and access one of the containers using the curl command.

1. **Create a custom bridge network**

Docker allows you to create your own bridge networks to better control the network environment for your containers. Here's how you can create a custom bridge network named "my-bridge-net":

```bash
docker network create --driver bridge my-bridge-net
```

2. **Create two containers on this custom bridge network**

Once the network is created, you can start containers on this network. We will create two containers: one running an Nginx server and another running a BusyBox image with curl installed.

```bash
docker run -d --name bridge_nginx --network my-bridge-net nginx
```

The above command creates a container named "bridge_nginx" on the "my-bridge-net" network, using the nginx image. The `-d` flag runs the container in detached mode.

```bash
docker run --rm --name bridge_busybox --network my-bridge-net radial/busyboxplus:curl curl bridge_nginx:80
```

The second command creates a container named "bridge_busybox" on the same network, using the radial/busyboxplus:curl image. The `--rm` flag removes the container after it exits. The `curl bridge_nginx:80` part of the command uses the curl command inside the container to access the "bridge_nginx" container on port 80.

## Overlay Network Driver

### Concepts

The overlay network driver enables multi-host networking, ideal for Docker Swarm clusters. It allows services on different Docker hosts to communicate as if they were on the same host.

- **Utilization of VXLAN Data Plane**: The Overlay Network Driver leverages a VXLAN data plane, enabling the underlying network infrastructure (underlay) to route data between hosts. This functionality is transparent to the containers, allowing them to communicate effortlessly.

- **Automatic Configuration**: Network interfaces, bridges, and other relevant network entities are automatically configured on each host as required. This feature simplifies the setup process, reducing the need for manual configuration.

- **Use Cases**: Predominantly, the Overlay Network Driver is employed for facilitating networking between containers within a Docker swarm, allowing efficient communication across different hosts.

Diagram:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Docker Swarm Cluster                                                                                              │
│                                                                                                                  │
│  ┌───────────────────────────────────────────────────┐    ┌───────────────────────────────────────────────────┐  │
│  │Host 1 (External IP - 192.168.50.10)               │    │Host 2 (External IP - 192.168.50.11)               │  │
│  │                                                   │    │                                                   │  │
│  │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐ │    │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐ │  │
│  │  Overlay Subnet: 10.0.1.0/24                      │    │  Overlay Subnet: 10.0.2.0/24                      │  │
│  │ │                                               │ │    │ │                                               │ │  │
│  │                                                   │    │                                                   │  │
│  │ │ ┌───────────────────────────────────────────┐ │ │    │ │ ┌───────────────────────────────────────────┐ │ │  │
│  │   │                 Container                 │   │    │   │                 Container                 │   │  │
│  │ │ └───────────────────────────────────────────┘ │ │    │ │ └───────────────────────────────────────────┘ │ │  │
│  │                                                   │    │                                                   │  │
│  │ │                          ┌──────────────────┐ │ │    │ │ ┌──────────────────┐                          │ │  │
│  │                            │  eth0: 10.0.1.2  │   │    │   │  eth0: 10.0.2.2  │                            │  │
│  │ │                          └─────────┬────────┘ │ │    │ │ └─────────┬────────┘                          │ │  │
│  │                                      │            │    │             │                                     │  │
│  │ │                                    │          │ │    │ │           │                                   │ │  │
│  │                            ┌─────────┴────────┐   │    │   ┌─────────┴────────┐                            │  │
│  │ │                          │       veth       │ │ │    │ │ │       veth       │                          │ │  │
│  │                            └─────────┬────────┘   │    │   └─────────┬────────┘                            │  │
│  │ │                                    │          │ │    │ │           │                                   │ │  │
│  │                                      │            │    │             │                                     │  │
│  │ │                          ┌─────────┴────────┐ │ │    │ │ ┌─────────┴────────┐                          │ │  │
│  │                            │ bridge: 10.0.1.1 │   │    │   │ bridge: 10.0.2.1 │                            │  │
│  │ │                          └─────────┬────────┘ │ │    │ │ └─────────┬────────┘                          │ │  │
│  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─  │    │  ─ ─ ─ ─ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  │
│  │                                      │            │    │             │                                     │  │
│  └──────────────────────────────────────┼────────────┘    └─────────────┼─────────────────────────────────────┘  │
│                                         └───────────────┬───────────────┘                                        │
│                                                         │                                                        │
│                                       ┌─────────────────┴────────────────┐                                       │
│                                       │   Overlay Network: 10.0.0.0/16   │                                       │
│                                       └──────────────────────────────────┘                                       │
│                                                                                                                  │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

                                                © Minh Hung Phan
```

Description:

In the diagram, the overlay network plays a crucial role in providing connectivity between containers on Host 1 and Host 2. Here's a step-by-step process on how the Docker overlay network driver enables this:

1. When the overlay network is created, Docker creates a network bridge on each host participating in the Swarm cluster. This is used for routing network packets to and from containers on that host.

2. A Virtual Extensible LAN (VXLAN) interface is created which provides a layer 2 (Ethernet) network on top of the layer 3 (IP) network. This allows containers on different hosts to act as if they are on the same subnet.

3. When a container on Host 1 wants to send data to a container on Host 2, it sends a network packet to the local Docker bridge.

4. This packet is encapsulated by the VXLAN and sent over the underlying network (the physical network connecting the Docker hosts) to the Docker bridge on the destination host (Host 2 in this case).

5. The Docker bridge on Host 2 then forwards this packet to the destination container.

6. For inbound traffic, the process is reversed. Network packets from Host 2 are sent to the Docker bridge on Host 1, which forwards them to the appropriate container.

This way, the overlay network provides seamless networking between containers, regardless of which host they are running on. Each container thinks it's communicating with another container on the same network, when in fact, the traffic might be routed across multiple Docker hosts.

### Hands-On

1. **Create an overlay network**

Use the following command to create an overlay network named 'my-overlay-net':

```bash
docker network create --driver overlay my-overlay-net
```

2. **Create services on the overlay network**

We will create two services on this overlay network: an Nginx service and a Busybox service.

- **Nginx service**

Use the following command to create an Nginx service named 'overlay_nginx':

```bash
docker service create --name overlay_nginx --network my-overlay-net nginx
```

- **Busybox service**

Use the following command to create a Busybox service named 'overlay_busybox'. This service will attempt to connect to the Nginx service:

```bash
docker service create --name overlay_busybox --network my-overlay-net radial/busyboxplus:curl sh -c 'curl overlay_nginx'
```

3. **Verify the Connection**

To confirm that the Busybox service has successfully connected to the Nginx service, we will inspect the logs of the 'overlay_busybox' service. The command to do this is:

```bash
docker service logs overlay_busybox
```

In the log output, you should see the message "Welcome to nginx". This confirms that the connection to the Nginx service over the overlay network was successful.

## MACVLAN Network Driver

### Concepts

The MACVLAN Network Driver provides a streamlined solution by linking container interfaces directly to host interfaces. This lightweight design results in less latency and greater efficiency.

- **Direct Association with Linux Interfaces**: Unlike the traditional bridge interface, the MACVLAN Network Driver connects directly with Linux interfaces, ensuring a more immediate and less cluttered data pathway. The MACVLAN network driver assigns a MAC address to each container's virtual network interface, making it appear as a physical device on your network.

- **Increased Efficiency**: The lightweight design results in less latency, enabling faster data transfer and more efficient network operation.

- **Configuration Difficulty**: The MACVLAN Network Driver may be harder to set up due to its increased dependency on the external network.

- **Greater Dependency**: This network driver has a higher dependency on the external network, which may require additional network management.

- **Use Cases**: The MACVLAN Network Driver is particularly beneficial in situations demanding extremely low latency or when there is a requirement for containers with IP addresses in the external subnet. This makes it a valuable tool in performance-critical environments or configurations that necessitate direct interaction with external network resources.

Diagram:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Single Host                                                                                                       │
│                                                                                                                  │
│                                                                                                                  │
│     ┌──────────────────────────────────────────────┐        ┌──────────────────────────────────────────────┐     │
│     │                                              │        │                                              │     │
│     │                  Container                   │        │                  Container                   │     │
│     │                                              │        │                                              │     │
│     └──────────────────────────────────────────────┘        └──────────────────────────────────────────────┘     │
│                                                                                                                  │
│                                 ┌──────────────────┐        ┌──────────────────┐                                 │
│                                 │ eth0: 10.100.0.2 │        │ eth0: 10.100.0.3 │                                 │
│                                 └────────┬─────────┘        └──────────┬───────┘                                 │
│                                          │                             │                                         │
│                                          │                             │                                         │
│                                          └──────────────┬──────────────┘                                         │
│                                                         │                                                        │
│                                             ┌───────────┴───────────┐                                            │
│                                             │        macvlan        │                                            │
│                                             └───────────┬───────────┘                                            │
│                                                         │                                                        │
│                                             ┌───────────┴───────────┐                                            │
│                                             │   eth0: 10.100.0.1    │                                            │
│                                             └───────────┬───────────┘                                            │
│                                                         │                                                        │
│                                                         │                                                        │
└─────────────────────────────────────────────────────────┼────────────────────────────────────────────────────────┘
                                                          │                                                         
                                                          │                                                         
                                         ┌────────────────┴─────────────────┐                                       
                                         │ Physical Network : 10.100.0.0/24 │                                       
                                         └──────────────────────────────────┘                                                                                  

                                                    © Minh Hung Phan
```

Description:


In the diagram, here's how the Macvlan network driver works:

1. **Physical Network**: Your physical network is defined as the `10.100.0.0/24` subnet. This means that any device connected to this network should have an IP address in the range `10.100.0.1` to `10.100.0.254`.

2. **Host's `eth0` Interface**: The host machine's physical network interface (`eth0`) has been assigned the IP address `10.100.0.1`. This means that the host machine is part of the `10.100.0.0/24` subnet and can communicate with other devices on this network.

3. **Macvlan Network**: The Macvlan network driver creates a new virtual network interface for each container. These interfaces are "children" of the host's `eth0` interface, but they have their own unique MAC and IP addresses. This allows the containers to communicate directly with the `10.100.0.0/24` network as if they were physical devices connected to it.

4. **Containers**: Container 1 and Container 2 each have a virtual network interface created by the Macvlan driver. These interfaces have been assigned the IP addresses `10.100.0.2` and `10.100.0.3`, respectively. This means that the containers are also part of the `10.100.0.0/24` subnet and can communicate with other devices on this network, including each other.

In this setup, each container appears as a separate device on the `10.100.0.0/24` network, and they can communicate with other devices on this network as if they were physically connected to it. However, due to a limitation in the Linux kernel, the host machine (with IP `10.100.0.1`) cannot directly communicate with the containers over the `eth0` interface. To allow communication between the host and the containers, you would need to create a separate Macvlan interface for the host or use a different method.

This setup provides network isolation for the containers, as each container has its own network interface and IP address. It also allows the containers to have a specific IP address on a specific network, which can be useful in certain scenarios.

**Explanation**: 

The reason the Docker host cannot directly communicate with the containers over the `eth0` interface when using the Macvlan network driver is due to a limitation in the Linux kernel, which is the underlying technology Docker is built upon.

The Macvlan driver works by creating virtual interfaces that are "children" of a physical interface on the host. These child interfaces can have their own MAC and IP addresses, which allows them to appear as separate devices on the network.

However, the Linux kernel prevents child interfaces created by Macvlan from communicating with their parent interface for security and functionality reasons. This is known as the "Macvlan's Bridge Loop Avoidance" issue.

This means that while the containers can communicate with other devices on the network, they cannot communicate with the Docker host over the same interface (`eth0` in this case) that the Macvlan network is associated with.

There are workarounds to this limitation. One common solution is to create a separate Macvlan interface for the host, which allows the host to communicate with the containers as if it were another device on the network. Another solution is to use a different network driver that does not have this limitation, such as the Bridge driver, depending on your specific requirements and network configuration.

### Hands-On

1. **Create a MACVLAN network**

Use the following command to create a MACVLAN network:

```bash
docker network create -d macvlan --subnet 192.168.0.0/24 --gateway 192.168.0.1 -o parent=eth0 my-macvlan-net
```

This command creates a Macvlan network named `my-macvlan-net` with the subnet `192.168.0.0/24` and the gateway `192.168.0.1`. The `-o parent=eth0` option associates this network with the `eth0` interface on the Docker host.

2. **Create two containers on this MACVLAN network**

Run the following commands to create two containers on the MACVLAN network:

```bash
docker run -d --name macvlan_nginx --net my-macvlan-net nginx
docker run --rm --name macvlan_busybox --net my-macvlan-net radial/busyboxplus:curl curl 192.168.0.2:80
```

The first command runs a container named `macvlan_nginx` using the `nginx` image, and connects it to the `my-macvlan-net` network. The second command runs a container named `macvlan_busybox` using the `radial/busyboxplus:curl` image, connects it to the `my-macvlan-net` network, and then uses `curl` to send a HTTP request to `192.168.0.2:80`, which is presumably the IP address and port that the `nginx` server is listening on.

With this setup, the containers would appear as separate devices on the `192.168.0.0/24` network, and they would be able to communicate with other devices on this network as if they were physically connected to it.

**Note**: 

- The IP address `192.168.0.2` in the `curl` command should be the IP address assigned to the `macvlan_nginx` container on the `my-macvlan-net` network. Docker does not automatically assign specific IP addresses to containers, so you would need to either specify the IP address when you run the container (using the `--ip` option), or check the IP address after the container is running (using the `docker inspect` command).

- The `macvlan_busybox` container is removed after the `curl` command is executed due to the `--rm` option. If you want to keep the container running after the command is executed, you should remove this option.

## None Network Driver

### Concepts

The None Network Driver does not deliver any network implementation, thereby creating a completely isolated environment for the container.

- **Complete Isolation**: The None Network Driver ensures complete segregation from other containers and the host, providing an environment solely dedicated to the specific container.

- **Manual Configuration:** For those seeking networking with the None driver, all settings and configuration must be manually implemented. This offers total control over the network setup.

- **Network Namespace Creation**: Although it doesn't create interfaces or endpoints, the None Network Driver still generates a separate network namespace for each container. 

- **Use Cases**: The None Network Driver proves advantageous when there is no requirement for container networking or in instances where the user desires to configure the network personally. It is particularly useful for specific scenarios that demand full control over the network configuration or when utmost isolation is needed.

Diagram:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Single Host                                                                                                       │
│                                                                                                                  │
│   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─     ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│    Container Network Namespace                       │     Container Network Namespace                       │   │
│   │                                                       │                                                      │
│     ┌──────────────────────────────────────────────┐ │      ┌──────────────────────────────────────────────┐ │   │
│   │ │                                              │      │ │                                              │     │
│     │                  Container                   │ │      │                  Container                   │ │   │
│   │ │                                              │      │ │                                              │     │
│     └──────────────────────────────────────────────┘ │      └──────────────────────────────────────────────┘ │   │
│   │                                                       │                                                      │
│                                                      │                                                       │   │
│   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─     └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─    │
│                                                                                                                  │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

                                                © Minh Hung Phan
```

Description:

The None Network Driver is a very straightforward Docker network driver that essentially provides no networking for Docker containers.

When you use the None Network Driver to set up a Docker container, here's what happens:

1. **Network Namespace Creation**: When a Docker container is started, it typically gets its own isolated environment, known as a namespace. This includes a network namespace, which is a virtual copy of the host's network stack. This means the container has its own network devices, IP addresses, routing tables, etc. The None Network Driver does create a network namespace for each container, but unlike other drivers, it doesn't configure any network interfaces or connections in this namespace.

2. **No Network Connection**: The Docker container is completely isolated in terms of networking. It doesn't have any access to the network of the host machine or any other Docker container. Essentially, it's like the container is on an island with no bridge or ferry to the mainland or any other island.

3. **Manual Configuration Needed for Networking**: If you need the Docker container to have network access, you'll have to set it up manually. This means you have to manually create and configure the network interfaces, assign IP addresses, set up routing tables, etc. In most cases, this isn't what you want as it requires a lot of manual work and knowledge of network configuration. But there are cases where this level of control is necessary or desirable, for instance, when setting up specialized network configurations for testing or security purposes.

So, to put it simply, when you use the None Network Driver, you're saying "I don't want Docker to handle networking for this container at all. If I want networking, I'll do it myself". This can be useful for certain advanced use cases, but for most users, one of the other Docker network drivers will be a better choice as they handle all the networking setup automatically.

### Hands-on

1. **Create a container with no network**

We will create a Docker container running an Nginx server, but with no network connectivity. This can be done using the `--net none` option in the `docker run` command.

```bash
docker run --net none -d --name none_nginx nginx
```

This command creates a new Docker container with the name `none_nginx`, running the latest version of Nginx. The `--net none` option ensures that the container has no external network access.

2. **Attempt to connect to the container**

Now, we will try to connect to the `none_nginx` container using another Docker container. This second container will have the `radial/busyboxplus:curl` image, which includes the `curl` command.

```bash
docker run --rm radial/busyboxplus:curl curl none_nginx:80
```

This command attempts to connect to the `none_nginx` container on port 80. Since the `none_nginx` container has no network, this connection should fail.


## Relevant Documentation

- [Docker Network Drivers](https://docs.docker.com/network/drivers/)
- [Understanding Docker Networking Drivers and Use Cases](https://www.docker.com/blog/understanding-docker-networking-drivers-use-cases/)

## Conclusion

Understanding Docker's various network drivers helps to customize your container networking according to your application's requirements. Each network driver has unique features and use cases that can improve the functionality and efficiency of your Docker containers.